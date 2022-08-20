module Crudable
  extend ActiveSupport::Concern

  included do
    before_action :prepare_collection, only: %i[index]
    before_action :prepare_new_object, only: %i[new create]
    before_action :prepare_object, only: %i[show edit update destroy]

    assign_resource_class_accessors
  end

  module ClassMethods
    attr_accessor :resource_class,
                  :resource_collection_variable,
                  :resource_object_variable,
                  :resource_pagy_variable,
                  :resource_route_namespaces,
                  :resource_collection_path,
                  :resource_object_path,
                  :resource_modal_form,
                  :resource_collection_includes,
                  :resource_flash_messages

    RESOURCE_ACTIONS = %i[index show new create edit update destroy].freeze

    def crud_to(options = {})
      options.symbolize_keys!
      options.assert_valid_keys(
        :class,
        :collection_variable,
        :object_variable,
        :route_namespaces,
        :collection_path,
        :object_path,
        :modal_form,
        :collection_includes,
        :flash_messages,
        :only_actions
      )
      only_actions = options.delete(:only_actions)
      only_actions = only_actions.present? ? only_actions.map(&:to_sym) : RESOURCE_ACTIONS

      assign_resource_class_accessors(options)
      define_valid_resource_actions(only_actions)
      format_request_resource_actions(only_actions)
    end

    private

    def assign_resource_class_accessors(options = {}) # rubocop:disable Metrics/AbcSize
      self.resource_class = options.fetch(:class, (name.split('::').last.sub(/Controller$/, '').singularize.constantize rescue nil)) # rubocop:disable Style/RescueModifier
      self.resource_collection_variable = options.fetch(:collection_variable, ("@#{resource_class.name.underscore.pluralize}" rescue :collection)).to_sym # rubocop:disable Style/RescueModifier
      self.resource_object_variable = options.fetch(:object_variable, ("@#{resource_class.name.underscore}" rescue :object)).to_sym # rubocop:disable Style/RescueModifier
      self.resource_pagy_variable = :@pagy

      self.resource_route_namespaces = options.fetch(:route_namespaces, name.underscore.split('/')[0..-2]).map(&:to_sym)
      self.resource_collection_path = options.fetch(:collection_path, nil)
      self.resource_object_path = options.fetch(:object_path, nil)

      self.resource_modal_form = options.fetch(:modal_form, false)
      self.resource_collection_includes = options.fetch(:collection_includes, [])
      self.resource_flash_messages = options.fetch(:flash_messages, {})
    end

    def define_valid_resource_actions(only_actions)
      (RESOURCE_ACTIONS - only_actions).each do |action|
        undef_method(action)
      end
    end

    def format_request_resource_actions(only_actions)
      effected_actions = only_actions & %i[new edit]
      only_turbo_stream_for(*effected_actions) if resource_modal_form
    end
  end

  def index
    pagy, collection = pagy(instance_variable_get(self.class.resource_collection_variable))
    instance_variable_set(self.class.resource_pagy_variable, pagy)
    instance_variable_set(self.class.resource_collection_variable, collection)
    block_given? ? yield : render(:index)
  end

  def show
    render(:show)
  end

  def new
    render(:new)
  end

  def create
    object = instance_variable_get(self.class.resource_object_variable)
    object.assign_attributes(resource_permitted_params)
    created = object.save

    return yield(created) if block_given?

    if created
      set_flash_message(:notice, :created)
      redirect_to resource_after_create_or_update_path
    else
      template = self.class.resource_modal_form ? :reform : :new
      render(template, status: :unprocessable_entity)
    end
  end

  def edit
    render(:edit)
  end

  def update
    object = instance_variable_get(self.class.resource_object_variable)
    updated = object.update(resource_permitted_params)

    return yield(updated) if block_given?

    if updated
      set_flash_message(:notice, :updated)
      redirect_to resource_after_create_or_update_path
    else
      template = self.class.resource_modal_form ? :reform : :edit
      render(template, status: :unprocessable_entity)
    end
  end

  def destroy
    object = instance_variable_get(self.class.resource_object_variable)
    object.destroy!

    return yield(object) if block_given?

    set_flash_message(:notice, :deleted)
    redirect_to(resource_after_destroy_path)
  end

  private

  def set_flash_message(type, key, flash_now: false)
    message = self.class.resource_flash_messages.fetch(key, nil)
    (flash_now ? flash.now : flash)[type] = message if message
  end

  def resource_object_path
    object = instance_variable_get(self.class.resource_object_variable)
    custom_path_method = self.class.resource_object_path
    custom_path_method ? send(custom_path_method, object) : polymorphic_path([*self.class.resource_route_namespaces, object])
  end

  def resource_collection_path
    custom_path_method = self.class.resource_collection_path
    custom_path_method ? send(custom_path_method) : polymorphic_path([*self.class.resource_route_namespaces, self.class.resource_class])
  end

  def resource_after_create_or_update_path
    self.class.resource_modal_form ? resource_collection_path : resource_object_path
  end

  def resource_after_destroy_path
    resource_collection_path
  end

  def resource_permitted_params
    raise NotImplementedError, "You must define `resource_permitted_params` as instance method in #{self.class.name} class"
  end

  def resource_base_scope
    policy_scope(self.class.resource_class)
  end

  def prepare_collection
    collection = resource_base_scope.includes(self.class.resource_collection_includes)
    instance_variable_set(self.class.resource_collection_variable, collection)
    authorize(collection)
  end

  def prepare_new_object
    object = self.class.resource_class.new
    instance_variable_set(self.class.resource_object_variable, object)
    authorize(object)
  end

  def prepare_object
    object = resource_base_scope.find(params[:id])
    instance_variable_set(self.class.resource_object_variable, object)
    authorize(object)
  end
end

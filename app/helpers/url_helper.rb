module UrlHelper
  def link_to_modal(name = nil, options = nil, html_options = nil, &block)
    with_modal_options = { data: { turbo_frame: 'remote_modal' } }.deep_merge(options || {})
    link_to(name, with_modal_options, html_options, &block)
  end

  def button_to_delete(name = nil, options = nil, html_options = nil, &block)
    with_delete_options = {
      method: :delete,
      form: { data: { turbo_confirm: 'Are you sure?' } }
    }

    if block_given?
      options = with_delete_options.deep_merge(options || {})
    else
      html_options = with_delete_options.deep_merge(html_options || {})
    end

    button_to(name, options, html_options, &block)
  end

  def active_link_class(patterns, options = { class: 'active' })
    routeto = "#{controller_path}##{action_name}"
    matched = patterns.any? { |pattern| (pattern.include?('#') ? (pattern == routeto) : (pattern == controller_path)) }
    matched ? options[:class] : nil
  end
end

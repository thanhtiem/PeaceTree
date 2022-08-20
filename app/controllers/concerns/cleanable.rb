module Cleanable
  extend ActiveSupport::Concern

  def cleanup_uploaded_params(source_params, verify_keys = [])
    source_params.tap do |sprs|
      verify_keys.each { |key| sprs.delete(key) if sprs[key].is_a?(String) }
    end
  end
end

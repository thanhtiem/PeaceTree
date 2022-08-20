module ImageHelper
  def attachment_image_tag(source, options = {})
    if source.attached?
      image_tag(source, options)
    else
      image_pack_tag(options.delete(:default) || 'missing.png', **options)
    end
  end
end

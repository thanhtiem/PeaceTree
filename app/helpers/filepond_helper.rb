module FilepondHelper
  def filepond_initial_files(attachments)
    return [] unless attachments.attached?

    if attachments.is_a?(ActiveStorage::Attached::One)
      attachments = [attachments]
    end

    attachments.map do |attachment|
      attachment_url = rails_blob_url(attachment)
      attachment_blob = attachment.blob
      {
        source: attachment_url,
        options: {
          type: :local,
          file: {
            name: attachment_blob.filename,
            size: attachment_blob.byte_size,
            type: attachment_blob.content_type
          },
          metadata: {
            poster: attachment_url
          }
        }
      }
    end
  end
end

class ImageValidator < ActiveModel::EachValidator
  ALLOWED_CONTENT_TYPES = %w[image/jpeg image/jpg image/png image/webp].freeze
  MAX_SIZE = 5.megabytes

  def validate_each(record, attribute, value)
    return unless value.attached?

    unless value.content_type.in?(ALLOWED_CONTENT_TYPES)
      record.errors.add(attribute, "केवल JPEG, PNG, और WebP फ़ाइलें स्वीकार्य हैं")
    end

    if value.byte_size > MAX_SIZE
      record.errors.add(attribute, "फ़ाइल का आकार 5 MB से अधिक नहीं होना चाहिए")
    end
  end
end

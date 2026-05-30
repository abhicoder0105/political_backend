class Profile < ApplicationRecord
  validates :name, presence: { message: "नाम आवश्यक है" },
            format: { with: /\A[\p{L} .'-]+\z/, message: "नाम में केवल अक्षर और स्थान हो सकते हैं" }
  validates :title, length: { maximum: 200, message: "पद का नाम 200 अक्षर से अधिक नहीं होना चाहिए" }, allow_blank: true
  validates :party, length: { maximum: 200, message: "पार्टी का नाम 200 अक्षर से अधिक नहीं होना चाहिए" }, allow_blank: true
  validates :constituency, length: { maximum: 200, message: "निर्वाचन क्षेत्र 200 अक्षर से अधिक नहीं होना चाहिए" }, allow_blank: true
  validates :biography, length: { maximum: 5000, message: "जीवनी 5000 अक्षर से अधिक नहीं होनी चाहिए" }, allow_blank: true
  validates :photo, image: true, if: -> { photo.attached? }

  has_one_attached :photo

  def photo_url
    if photo.attached?
      Rails.application.routes.url_helpers.rails_blob_url(photo, host: "localhost:3000") rescue nil
    else
      read_attribute(:image_url)
    end
  end
end
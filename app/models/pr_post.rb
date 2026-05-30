class PrPost < ApplicationRecord
  belongs_to :user
  has_many_attached :media_files
  has_one_attached :uploaded_image

  enum :status, { draft: 0, scheduled: 1, published: 2 }

  validates :title, presence: { message: "शीर्षक आवश्यक है" },
            length: { minimum: 3, maximum: 500, message: "शीर्षक 3 से 500 अक्षरों के बीच होना चाहिए" }
  validates :content, presence: { message: "सामग्री आवश्यक है" },
            length: { minimum: 10, maximum: 50000, message: "सामग्री 10 से 50000 अक्षरों के बीच होनी चाहिए" }
  validates :language, presence: { message: "भाषा आवश्यक है" },
            length: { maximum: 50, message: "भाषा 50 अक्षर से अधिक नहीं होनी चाहिए" }
  validates :status, inclusion: { in: statuses.keys, message: "%{value} एक मान्य स्थिति नहीं है" }, allow_blank: true
  validates :uploaded_image, image: true, if: -> { uploaded_image.attached? }
  validate :published_at_cannot_be_in_future, if: -> { published_at.present? && status == 'published' }

  def display_image_url
    if uploaded_image.attached?
      Rails.application.routes.url_helpers.rails_blob_url(uploaded_image, host: "localhost:3000") rescue nil
    elsif media_files.attached?
      Rails.application.routes.url_helpers.rails_blob_url(media_files.first, host: "localhost:3000") rescue nil
    else
      read_attribute(:image_url)
    end
  end

  private

  def published_at_cannot_be_in_future
    if published_at > Time.current
      errors.add(:published_at, "प्रकाशित तिथि भविष्य की नहीं हो सकती")
    end
  end
end

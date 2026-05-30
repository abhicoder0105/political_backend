class Campaign < ApplicationRecord
  enum :target_support_status, { supporter: 0, neutral: 1, opposition: 2, unknown_support: 3 }
  enum :campaign_status, { draft: 0, scheduled: 1, active: 2, completed: 3 }

  validates :title, presence: { message: "शीर्षक आवश्यक है" },
            length: { minimum: 3, maximum: 500, message: "शीर्षक 3 से 500 अक्षरों के बीच होना चाहिए" }
  validates :language, presence: { message: "भाषा आवश्यक है" },
            length: { maximum: 50, message: "भाषा 50 अक्षर से अधिक नहीं होनी चाहिए" }
  validates :campaign_status, presence: { message: "स्थिति आवश्यक है" },
            inclusion: { in: campaign_statuses.keys, message: "%{value} एक मान्य स्थिति नहीं है" }
  validates :target_support_status, inclusion: { in: target_support_statuses.keys, message: "%{value} एक मान्य लक्ष्य स्थिति नहीं है" }, allow_blank: true
  validates :description, length: { maximum: 10000, message: "विवरण 10000 अक्षर से अधिक नहीं होना चाहिए" }, allow_blank: true
  validates :target_area, length: { maximum: 200, message: "लक्ष्य क्षेत्र 200 अक्षर से अधिक नहीं होना चाहिए" }, allow_blank: true
  validates :target_village, length: { maximum: 200, message: "लक्ष्य गांव 200 अक्षर से अधिक नहीं होना चाहिए" }, allow_blank: true
  validates :uploaded_image, image: true, if: -> { uploaded_image.attached? }
  validate :scheduled_at_cannot_be_in_past, if: -> { scheduled_at.present? && campaign_status == 'scheduled' }

  has_one_attached :uploaded_image

  def display_image_url
    if uploaded_image.attached?
      Rails.application.routes.url_helpers.rails_blob_url(uploaded_image, host: "localhost:3000") rescue nil
    else
      read_attribute(:image_url)
    end
  end

  private

  def scheduled_at_cannot_be_in_past
    if scheduled_at < Time.current
      errors.add(:scheduled_at, "निर्धारित तिथि भविष्य की होनी चाहिए")
    end
  end
end

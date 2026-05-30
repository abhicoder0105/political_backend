class WorkDone < ApplicationRecord
  belongs_to :population_record
  has_many_attached :proof_images
  has_one_attached :uploaded_image

  enum :status, { pending: 0, in_progress: 1, completed: 2, rejected: 3 }

  validates :title, presence: { message: "शीर्षक आवश्यक है" },
            length: { minimum: 3, maximum: 500, message: "शीर्षक 3 से 500 अक्षरों के बीच होना चाहिए" }
  validates :work_type, presence: { message: "कार्य प्रकार आवश्यक है" },
            length: { maximum: 200, message: "कार्य प्रकार 200 अक्षर से अधिक नहीं होना चाहिए" }
  validates :status, presence: { message: "स्थिति आवश्यक है" },
            inclusion: { in: statuses.keys, message: "%{value} एक मान्य स्थिति नहीं है" }
  validates :description, length: { maximum: 10000, message: "विवरण 10000 अक्षर से अधिक नहीं होना चाहिए" }, allow_blank: true
  validates :area, length: { maximum: 200, message: "क्षेत्र 200 अक्षर से अधिक नहीं होना चाहिए" }, allow_blank: true
  validates :village, length: { maximum: 200, message: "गांव 200 अक्षर से अधिक नहीं होना चाहिए" }, allow_blank: true
  validates :assigned_to, length: { maximum: 200, message: "जिम्मेदार व्यक्ति 200 अक्षर से अधिक नहीं होना चाहिए" }, allow_blank: true
  validates :budget, numericality: { greater_than_or_equal_to: 0, message: "बजट ऋणात्मक नहीं हो सकता" }, allow_nil: true
  validates :category, length: { maximum: 200, message: "श्रेणी 200 अक्षर से अधिक नहीं होनी चाहिए" }, allow_blank: true
  validates :remarks, length: { maximum: 5000, message: "टिप्पणियां 5000 अक्षर से अधिक नहीं होनी चाहिए" }, allow_blank: true
  validates :uploaded_image, image: true, if: -> { uploaded_image.attached? }
  validate :completed_at_cannot_be_in_future, if: -> { completed_at.present? }

  def display_image_url
    if uploaded_image.attached?
      Rails.application.routes.url_helpers.rails_blob_url(uploaded_image, host: "localhost:3000") rescue nil
    elsif proof_images.attached?
      Rails.application.routes.url_helpers.rails_blob_url(proof_images.first, host: "localhost:3000") rescue nil
    else
      read_attribute(:proof_image_url)
    end
  end

  private

  def completed_at_cannot_be_in_future
    if completed_at > Time.current
      errors.add(:completed_at, "पूर्ण तिथि भविष्य की नहीं हो सकती")
    end
  end
end

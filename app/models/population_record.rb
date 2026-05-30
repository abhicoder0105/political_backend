class PopulationRecord < ApplicationRecord
  belongs_to :vidhansabha, optional: true
  belongs_to :area_ref, class_name: "Area", optional: true, inverse_of: :population_records
  belongs_to :village_ward, optional: true
  has_many :work_dones, dependent: :destroy
  has_one_attached :aadhaar_document

  enum :gender, { unknown: 0, male: 1, female: 2, other: 3 }
  enum :rural_or_urban, { rural: 0, urban: 1 }
  enum :political_support_status, { supporter: 0, neutral: 1, opposition: 2, unknown_support: 3 }

  before_validation { self.name = full_name if name.blank? && full_name.present? }

  validates :name, presence: { message: "नाम आवश्यक है" },
            format: { with: /\A[\p{L} .'-]+\z/, message: "नाम में केवल अक्षर और स्थान हो सकते हैं", allow_blank: true }
  validates :phone_number, presence: { message: "फोन नंबर आवश्यक है" },
            format: { with: /\A\d{10}\z/, message: "फोन नंबर 10 अंकों का होना चाहिए" }
  validates :area, presence: { message: "क्षेत्र आवश्यक है" },
            length: { maximum: 200, message: "क्षेत्र 200 अक्षर से अधिक नहीं होना चाहिए" }
  validates :age, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 150, message: "आयु 1 से 150 के बीच होनी चाहिए" }, allow_nil: true
  validates :gender, inclusion: { in: genders.keys, message: "%{value} एक मान्य लिंग नहीं है" }
  validates :rural_or_urban, inclusion: { in: rural_or_urbans.keys, message: "%{value} एक मान्य वर्ग नहीं है" }
  validates :political_support_status, inclusion: { in: political_support_statuses.keys, message: "%{value} एक मान्य समर्थन स्थिति नहीं है" }
  validates :family_count, numericality: { only_integer: true, greater_than: 0, message: "परिवार संख्या धनात्मक होनी चाहिए" }, allow_nil: true
  validates :voter_id, length: { maximum: 50, message: "वोटर आईडी 50 अक्षर से अधिक नहीं होनी चाहिए" }, allow_blank: true
  validates :aadhaar_document, image: true, if: -> { aadhaar_document.attached? }

  scope :by_vidhansabha, ->(value) { where(vidhansabha_id: value) if value.present? }
  scope :by_area, ->(value) { where("LOWER(area) LIKE ?", "%#{sanitize_sql_like(value.downcase)}%") if value.present? }
  scope :by_village_or_ward, ->(value) { where("LOWER(village_or_ward) LIKE ?", "%#{sanitize_sql_like(value.downcase)}%") if value.present? }
  scope :by_rural_or_urban, ->(value) { where(rural_or_urban: rural_or_urbans[value]) if value.present? && rural_or_urbans.key?(value) }
  scope :by_gender, ->(value) { where(gender: genders[value]) if value.present? && genders.key?(value) }
  scope :by_phone_number, ->(value) { where("phone_number LIKE ?", "%#{sanitize_sql_like(value)}%") if value.present? }
  scope :by_age, ->(value) { where(age: value) if value.present? }
end

class Area < ApplicationRecord
  belongs_to :vidhansabha
  has_many :village_wards, dependent: :destroy
  has_many :population_records, foreign_key: :area_ref_id, dependent: :nullify, inverse_of: :area_ref

  validates :name, presence: { message: "नाम आवश्यक है" },
            length: { minimum: 2, maximum: 200, message: "नाम 2 से 200 अक्षरों के बीच होना चाहिए" },
            uniqueness: { scope: :vidhansabha_id, message: "इस विधानसभा में यह क्षेत्र पहले से मौजूद है" }
end

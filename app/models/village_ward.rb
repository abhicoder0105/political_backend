class VillageWard < ApplicationRecord
  belongs_to :area
  has_many :population_records, dependent: :nullify

  enum :kind, { rural: 0, urban: 1 }

  validates :name, presence: { message: "नाम आवश्यक है" },
            length: { minimum: 2, maximum: 200, message: "नाम 2 से 200 अक्षरों के बीच होना चाहिए" },
            uniqueness: { scope: :area_id, message: "इस क्षेत्र में यह गांव/वार्ड पहले से मौजूद है" }
  validates :kind, inclusion: { in: kinds.keys, message: "%{value} एक मान्य प्रकार नहीं है" }
end

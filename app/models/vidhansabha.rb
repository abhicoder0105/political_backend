class Vidhansabha < ApplicationRecord
  has_many :areas, dependent: :destroy
  has_many :population_records, dependent: :nullify

  validates :name, presence: { message: "नाम आवश्यक है" },
            length: { minimum: 2, maximum: 200, message: "नाम 2 से 200 अक्षरों के बीच होना चाहिए" },
            uniqueness: { message: "यह विधानसभा पहले से मौजूद है" }
  validates :district, length: { maximum: 200, message: "जिला 200 अक्षर से अधिक नहीं होना चाहिए" }, allow_blank: true
  validates :state, length: { maximum: 200, message: "राज्य 200 अक्षर से अधिक नहीं होना चाहिए" }, allow_blank: true
end

class CampaignSupport < ApplicationRecord
  belongs_to :campaign

  validates :name, presence: { message: "नाम आवश्यक है" },
            format: { with: /\A[\p{L} .'-]+\z/, message: "नाम में केवल अक्षर और स्थान हो सकते हैं" }
  validates :phone_number, presence: { message: "मोबाइल नंबर आवश्यक है" },
            format: { with: /\A\d{10}\z/, message: "मोबाइल नंबर 10 अंकों का होना चाहिए" }
  validates :area, length: { maximum: 200, message: "क्षेत्र 200 अक्षर से अधिक नहीं होना चाहिए" }, allow_blank: true
  validates :village_or_ward, length: { maximum: 200, message: "गांव 200 अक्षर से अधिक नहीं होना चाहिए" }, allow_blank: true
  validates :message, length: { maximum: 2000, message: "संदेश 2000 अक्षर से अधिक नहीं होना चाहिए" }, allow_blank: true
end

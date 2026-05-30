class Permission < ApplicationRecord
  has_many :role_permissions, dependent: :destroy

  validates :key, presence: { message: "कुंजी आवश्यक है" },
            uniqueness: { message: "यह कुंजी पहले से मौजूद है" },
            format: { with: /\A[a-z_]+\z/, message: "कुंजी में केवल लोअरकेस अक्षर और अंडरस्कोर हो सकते हैं" }
  validates :name, length: { maximum: 200, message: "नाम 200 अक्षर से अधिक नहीं होना चाहिए" }, allow_blank: true
end

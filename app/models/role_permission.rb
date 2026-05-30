class RolePermission < ApplicationRecord
  belongs_to :permission

  enum :role, User.roles

  validates :role, presence: { message: "भूमिका आवश्यक है" },
            inclusion: { in: roles.keys, message: "%{value} एक मान्य भूमिका नहीं है" }
  validates :permission_id, uniqueness: { scope: :role, message: "यह अनुमति इस भूमिका के लिए पहले से मौजूद है" }
end

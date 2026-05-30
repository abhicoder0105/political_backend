class RequestActivity < ApplicationRecord
  belongs_to :public_request
  belongs_to :user, optional: true

  validates :action, presence: { message: "कार्रवाई आवश्यक है" },
            length: { maximum: 200, message: "कार्रवाई 200 अक्षर से अधिक नहीं होनी चाहिए" }
end

class RequestComment < ApplicationRecord
  belongs_to :public_request
  belongs_to :user, optional: true

  validates :comment, presence: { message: "टिप्पणी आवश्यक है" },
            length: { minimum: 1, maximum: 5000, message: "टिप्पणी 5000 अक्षर से अधिक नहीं होनी चाहिए" }
end

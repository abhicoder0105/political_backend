module Api
  module Admin
    class BaseController < ApplicationController
      before_action :authenticate_user!
      before_action :reject_public_user!

      private

      def reject_public_user!
        render json: { error: "आपको इस पेज की अनुमति नहीं है" }, status: :forbidden if current_user&.public_user?
      end

      def ensure_permission!(permission_key)
        authorize_permission!(permission_key)
      end
    end
  end
end

module Api
  class BaseController < ApplicationController
    before_action :authenticate_user!

    private

    def require_permission!(permission_key)
      authorize_permission!(permission_key)
    end
  end
end

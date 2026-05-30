module Api
  class PermissionsController < BaseController
    def index
      render json: Permission.order(:key)
    end
  end
end

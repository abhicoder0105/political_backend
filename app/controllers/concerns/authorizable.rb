module Authorizable
  extend ActiveSupport::Concern

  def authorize_permission!(permission_key)
    authenticate_user!
    return if performed?
    return if current_user.permission?(permission_key)

    render json: { error: "Forbidden" }, status: :forbidden
  end
end

class ApplicationController < ActionController::API
  include JsonWebToken
  include Authorizable

  attr_reader :current_user

  rescue_from ArgumentError, with: :handle_argument_error
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid

  def authenticate_user!
    authenticate_request!
    return if performed?

    @current_user = User.find_by(id: current_jwt_payload[:user_id])
    render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
  end

  def require_admin!
    authenticate_user!
    return if performed?

    return if current_user.super_admin? || current_user.admin?

    render json: { error: "Forbidden" }, status: :forbidden
  end

  private

  def render_model_errors(record)
    render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
  end

  def handle_argument_error(exception)
    render json: { errors: [exception.message] }, status: :unprocessable_entity
  end

  def handle_not_found(exception)
    render json: { error: "रेकॉर्ड नहीं मिला" }, status: :not_found
  end

  def handle_record_invalid(exception)
    render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end
end

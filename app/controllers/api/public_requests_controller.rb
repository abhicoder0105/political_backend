module Api
  class PublicRequestsController < ApplicationController
    before_action :authenticate_user!, except: %i[create track]
    before_action :set_public_request, only: %i[show update destroy]

    def index
      records = current_user.public_user? ? current_user.submitted_requests : PublicRequest.all
      records = records.where(status: PublicRequest.statuses[params[:status]]) if params[:status].present? && PublicRequest.statuses.key?(params[:status])
      render json: records.order(created_at: :desc).as_json(include: [:request_comments, :request_histories])
    end

    def show
      render json: @public_request
    end

    def create
      load_optional_current_user
      record = PublicRequest.new(public_request_params)
      record.public_user ||= current_user if defined?(current_user) && current_user&.public_user?
      record.attachment.attach(params[:attachment]) if params[:attachment].present?

      if record.save
        render json: { message: "Request submitted", request: record }, status: :created
      else
        render json: { error: "Request could not be submitted", errors: record.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      old_status = @public_request.status
      if @public_request.update(public_request_params)
        create_history(@public_request, old_status) if old_status != @public_request.status
        render json: @public_request
      else
        render_model_errors(@public_request)
      end
    end

    def track
      request = PublicRequest.find_by!(id: params[:id], phone_number: params.require(:phone_number))
      render json: request.as_json(include: [:request_comments, :request_histories])
    end

    def destroy
      @public_request.destroy
      head :no_content
    end

    private

    def set_public_request
      @public_request = PublicRequest.find(params[:id])
    end

    def public_request_params
      params.require(:public_request).permit(:request_title, :name, :phone_number, :area, :village_or_ward, :category, :description, :image_url, :document_url, :severity, :status, :assigned_to, :public_user_id)
    end

    def load_optional_current_user
      token = request.authorization.to_s[/\ABearer (.+)\z/, 1]
      return if token.blank?

      payload = jwt_decode(token)
      @current_user = User.find_by(id: payload[:user_id])
    rescue JWT::DecodeError
      nil
    end

    def create_history(request, old_status)
      request.request_histories.create!(
        user: current_user,
        from_status: old_status,
        to_status: request.status,
        note: "Status updated"
      )
    end
  end
end

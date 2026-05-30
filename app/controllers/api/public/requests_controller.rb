module Api
  module Public
    class RequestsController < ApplicationController
      before_action :set_request_for_status, only: %i[status]
      before_action :set_public_edit_request, only: %i[update]

      def create
        request_record = PublicRequest.new(public_request_params)

        if request_record.save
          render json: { message: "शिकायत सफलतापूर्वक दर्ज हुई", request: request_record }, status: :created
        else
          render json: { errors: request_record.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def status
        render json: @request.as_json(only: %i[id request_title category description area village_or_ward severity status assigned_to public_response expected_resolution_date resolution_summary created_at])
      end

      def update
        unless @request.new_request?
          return render json: { error: "Processing शुरू होने के बाद public edit allowed नहीं है" }, status: :forbidden
        end

        if @request.update(public_edit_params)
          @request.request_activities.create!(action: "public_edited", notes: "Public user edited request")
          render json: @request
        else
          render json: { errors: @request.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_request_for_status
        @request = PublicRequest.find(params[:id])
      end

      def set_public_edit_request
        @request = PublicRequest.find_by!(id: params[:id], phone_number: params.require(:phone_number))
      end

      def public_request_params
        params.require(:public_request).permit(:request_title, :name, :phone_number, :area, :village_or_ward, :category, :description, :image_url, :document_url)
      end

      def public_edit_params
        params.require(:public_request).permit(:description, :image_url, :document_url)
      end
    end
  end
end

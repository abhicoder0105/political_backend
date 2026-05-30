module Api
  module Admin
    class RequestsController < BaseController
      before_action -> { ensure_permission!("manage_requests") }
      before_action :set_request, only: %i[show update destroy assign status severity]

      def index
        records = filtered_requests
        total_count = records.count
        page = [params.fetch(:page, 1).to_i, 1].max
        per_page = params.fetch(:per_page, 25).to_i.clamp(10, 100)
        total_pages = (total_count.to_f / per_page).ceil

        render json: {
          data: records.offset((page - 1) * per_page).limit(per_page).map { |request| serialize_request(request) },
          meta: {
            current_page: page,
            total_pages: total_pages,
            total_count: total_count,
            per_page: per_page
          }
        }
      end

      def show
        render json: serialize_request(@request, detail: true)
      end

      def create
        request_record = PublicRequest.new(request_params)

        if request_record.save
          activity(request_record, "created", nil, request_record.status, "Admin created request")
          render json: serialize_request(request_record, detail: true), status: :created
        else
          render json: { errors: request_record.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        old_values = @request.slice(*trackable_fields)

        if @request.update(request_params)
          track_changes(@request, old_values)
          render json: serialize_request(@request, detail: true)
        else
          render json: { errors: @request.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        return render json: { error: "आपको इस action की अनुमति नहीं है" }, status: :forbidden unless current_user.permission?("manage_requests")

        @request.destroy
        head :no_content
      end

      def assign
        old_value = @request.assigned_to
        @request.update!(assigned_to: params[:assigned_to], assigned_to_user_id: params[:assigned_to_id])
        activity(@request, "assigned_worker_changed", old_value, @request.assigned_to, params[:notes])
        render json: serialize_request(@request, detail: true)
      end

      def status
        old_value = @request.status
        @request.update!(status: params.require(:status), escalated: params[:status] == "escalated")
        activity(@request, "status_changed", old_value, @request.status, params[:notes])
        render json: serialize_request(@request, detail: true)
      end

      def severity
        old_value = @request.severity
        @request.update!(severity: params.require(:severity))
        activity(@request, "severity_changed", old_value, @request.severity, params[:notes])
        render json: serialize_request(@request, detail: true)
      end

      private

      def filtered_requests
        records = PublicRequest.includes(:request_activities, :request_comments, :assigned_to_user).search_text(params[:search])
        records = records.where(status: PublicRequest.statuses[params[:status]]) if params[:status].present? && PublicRequest.statuses.key?(params[:status])
        records = records.where(severity: PublicRequest.severities[params[:severity]]) if params[:severity].present? && PublicRequest.severities.key?(params[:severity])
        records = records.where(category: params[:category]) if params[:category].present?
        records = records.where("LOWER(area) LIKE ?", "%#{PublicRequest.sanitize_sql_like(params[:area_id].to_s.downcase)}%") if params[:area_id].present?
        records = records.where("LOWER(village_or_ward) LIKE ?", "%#{PublicRequest.sanitize_sql_like(params[:village_id].to_s.downcase)}%") if params[:village_id].present?
        records = records.where(assigned_to_user_id: params[:assigned_to_id]) if params[:assigned_to_id].present?
        records = records.where("LOWER(assigned_to) LIKE ?", "%#{PublicRequest.sanitize_sql_like(params[:assigned_worker].to_s.downcase)}%") if params[:assigned_worker].present?
        records = records.where(created_at: Time.zone.parse(params[:created_from])..) if params[:created_from].present?
        records = records.where(created_at: ..Time.zone.parse(params[:created_to]).end_of_day) if params[:created_to].present?
        records = records.where(escalated: true) if params[:escalated].to_s == "true"
        records = records.unresolved if params[:unresolved].to_s == "true"
        sort_records(records)
      end

      def sort_records(records)
        case params[:sort]
        when "oldest"
          records.order(created_at: :asc)
        when "severity"
          records.order(severity: :desc, created_at: :desc)
        when "status"
          records.order(:status, created_at: :desc)
        when "area"
          records.order(:area, created_at: :desc)
        when "assigned_worker"
          records.order(:assigned_to, created_at: :desc)
        else
          records.order(created_at: :desc)
        end
      end

      def set_request
        @request = PublicRequest.find(params[:id])
      end

      def request_params
        params.require(:public_request).permit(
          :request_title, :name, :phone_number, :area, :village_or_ward, :category,
          :description, :severity, :status, :assigned_to, :assigned_to_user_id,
          :internal_notes, :public_response, :expected_resolution_date,
          :resolution_summary, :image_url, :document_url, :escalated
        )
      end

      def trackable_fields
        %w[request_title name phone_number area village_or_ward category description severity status assigned_to internal_notes public_response expected_resolution_date resolution_summary escalated]
      end

      def track_changes(request_record, old_values)
        trackable_fields.each do |field|
          old_value = old_values[field]
          new_value = request_record.public_send(field)
          next if old_value.to_s == new_value.to_s

          activity(request_record, "#{field}_changed", old_value, new_value, nil)
        end
      end

      def activity(request_record, action, old_value, new_value, notes)
        request_record.request_activities.create!(
          user: current_user,
          action: action,
          old_value: old_value,
          new_value: new_value,
          notes: notes
        )
      end

      def serialize_request(request_record, detail: false)
        data = request_record.as_json(
          only: %i[
            id request_title name phone_number area village_or_ward category
            description severity status assigned_to assigned_to_user_id internal_notes
            public_response expected_resolution_date resolution_summary escalated
            image_url document_url created_at updated_at
          ]
        )
        data["assigned_to_user"] = request_record.assigned_to_user&.as_json(only: %i[id name mobile_number role])
        return data unless detail

        data["activities"] = request_record.request_activities.order(created_at: :desc).as_json(include: { user: { only: %i[id name role] } })
        data["comments"] = request_record.request_comments.order(created_at: :desc).as_json(include: { user: { only: %i[id name role] } })
        data
      end
    end
  end
end

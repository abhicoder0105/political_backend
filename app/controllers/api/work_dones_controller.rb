module Api
  class WorkDonesController < BaseController
    before_action -> { require_permission!("manage_work") }
    before_action :set_work_done, only: %i[show update destroy]

    def index
      records = WorkDone.includes(:population_record).order(created_at: :desc)
      records = records.where(population_record_id: params[:population_record_id]) if params[:population_record_id].present?
      render json: records.map { |w| serialize(w) }
    end

    def show
      render json: serialize(@work_done)
    end

    def create
      record = WorkDone.new(work_done_params)
      record.uploaded_image.attach(params[:uploaded_image]) if params[:uploaded_image].present?
      record.proof_images.attach(params[:proof_images]) if params[:proof_images].present?
      record.save ? render(json: serialize(record), status: :created) : render_model_errors(record)
    end

    def update
      @work_done.uploaded_image.attach(params[:uploaded_image]) if params[:uploaded_image].present?
      @work_done.uploaded_image.purge if params[:remove_image] == "true" && !params[:uploaded_image].present?
      @work_done.proof_images.attach(params[:proof_images]) if params[:proof_images].present?
      @work_done.update(work_done_params) ? render(json: serialize(@work_done)) : render_model_errors(@work_done)
    end

    def destroy
      @work_done.destroy
      head :no_content
    end

    private

    def set_work_done
      @work_done = WorkDone.find(params[:id])
    end

    def work_done_params
      params.require(:work_done).permit(:population_record_id, :title, :work_type, :category, :description, :area, :village, :budget, :status, :assigned_to, :completed_at, :proof_image_url, :proof_images_url, :remarks)
    end

    def serialize(work)
      work.as_json(include: { population_record: { only: %i[id name phone_number area village_or_ward] } }).merge(
        image_url: work.display_image_url,
        has_uploaded_image: work.uploaded_image.attached?
      )
    end
  end
end

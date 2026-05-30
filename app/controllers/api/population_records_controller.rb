module Api
  class PopulationRecordsController < BaseController
    before_action -> { require_permission!("manage_population") }
    before_action :set_population_record, only: %i[show update destroy]

    def index
      records = PopulationRecord.includes(:vidhansabha, :area_ref, :village_ward)
        .by_vidhansabha(params[:vidhansabha])
        .by_area(params[:area])
        .by_village_or_ward(params[:village_or_ward])
        .by_rural_or_urban(params[:rural_or_urban])
        .by_age(params[:age])
        .by_gender(params[:gender])
        .by_phone_number(params[:phone_number])
        .order(created_at: :desc)

      render json: records.as_json(include: { work_dones: { only: %i[id title work_type status assigned_to completed_at] } })
    end

    def show
      render json: @population_record.as_json(include: :work_dones)
    end

    def create
      record = PopulationRecord.new(population_record_params)

      if record.save
        render json: record, status: :created
      else
        render_model_errors(record)
      end
    end

    def update
      if @population_record.update(population_record_params)
        render json: @population_record
      else
        render_model_errors(@population_record)
      end
    end

    def destroy
      @population_record.destroy
      head :no_content
    end

    private

    def set_population_record
      @population_record = PopulationRecord.find(params[:id])
    end

    def population_record_params
      params.require(:population_record).permit(
        :name, :full_name, :age, :gender, :phone_number, :address, :area, :village_or_ward,
        :rural_or_urban, :family_count, :aadhaar_image_url, :whatsapp_consent,
        :notes, :tags, :vidhansabha_id, :area_ref_id, :village_ward_id, :village,
        :ward, :booth_number, :voter_id, :aadhaar_document_url, :political_support_status,
        :assigned_worker, :political_engagement
      )
    end
  end
end

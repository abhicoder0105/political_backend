module Api
  class VillageWardsController < BaseController
    before_action -> { require_permission!("manage_areas") }
    before_action :set_village_ward, only: %i[show update destroy]

    def index
      records = VillageWard.includes(area: :vidhansabha).order(:name)
      render json: records.as_json(include: { area: { include: :vidhansabha } })
    end

    def show
      render json: @village_ward.as_json(include: { area: { include: :vidhansabha } })
    end

    def create
      record = VillageWard.new(village_ward_params)
      record.save ? render(json: record, status: :created) : render_model_errors(record)
    end

    def update
      @village_ward.update(village_ward_params) ? render(json: @village_ward) : render_model_errors(@village_ward)
    end

    def destroy
      @village_ward.destroy
      head :no_content
    end

    private

    def set_village_ward
      @village_ward = VillageWard.find(params[:id])
    end

    def village_ward_params
      params.require(:village_ward).permit(:name, :kind, :area_id)
    end
  end
end

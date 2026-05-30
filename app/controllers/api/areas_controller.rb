module Api
  class AreasController < BaseController
    before_action -> { require_permission!("manage_areas") }
    before_action :set_area, only: %i[show update destroy]

    def index
      areas = Area.includes(:vidhansabha, :village_wards).order(:name)
      render json: areas.as_json(include: [:vidhansabha, :village_wards])
    end

    def show
      render json: @area.as_json(include: [:vidhansabha, :village_wards])
    end

    def create
      record = Area.new(area_params)
      record.save ? render(json: record, status: :created) : render_model_errors(record)
    end

    def update
      @area.update(area_params) ? render(json: @area) : render_model_errors(@area)
    end

    def destroy
      @area.destroy
      head :no_content
    end

    private

    def set_area
      @area = Area.find(params[:id])
    end

    def area_params
      params.require(:area).permit(:name, :vidhansabha_id)
    end
  end
end

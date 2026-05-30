module Api
  class VidhansabhasController < BaseController
    before_action :set_vidhansabha, only: %i[show update destroy]

    def index
      render json: Vidhansabha.includes(areas: :village_wards).order(:name).as_json(include: { areas: { include: :village_wards } })
    end

    def show
      render json: @vidhansabha.as_json(include: { areas: { include: :village_wards } })
    end

    def create
      record = Vidhansabha.new(vidhansabha_params)
      record.save ? render(json: record, status: :created) : render_model_errors(record)
    end

    def update
      @vidhansabha.update(vidhansabha_params) ? render(json: @vidhansabha) : render_model_errors(@vidhansabha)
    end

    def destroy
      @vidhansabha.destroy
      head :no_content
    end

    private

    def set_vidhansabha
      @vidhansabha = Vidhansabha.find(params[:id])
    end

    def vidhansabha_params
      params.require(:vidhansabha).permit(:name, :district, :state)
    end
  end
end

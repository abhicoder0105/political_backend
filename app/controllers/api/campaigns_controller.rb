module Api
  class CampaignsController < BaseController
    before_action -> { require_permission!("manage_campaigns") }
    before_action :set_campaign, only: %i[show update destroy]

    def index
      render json: Campaign.order(created_at: :desc).map { |c| serialize(c) }
    end

    def show
      render json: serialize(@campaign)
    end

    def create
      record = Campaign.new(campaign_params)
      record.uploaded_image.attach(params[:uploaded_image]) if params[:uploaded_image].present?
      record.save ? render(json: serialize(record), status: :created) : render_model_errors(record)
    end

    def update
      @campaign.uploaded_image.attach(params[:uploaded_image]) if params[:uploaded_image].present?
      @campaign.uploaded_image.purge if params[:remove_image] == "true" && !params[:uploaded_image].present?
      @campaign.update(campaign_params) ? render(json: serialize(@campaign)) : render_model_errors(@campaign)
    end

    def destroy
      @campaign.destroy
      head :no_content
    end

    private

    def set_campaign
      @campaign = Campaign.find(params[:id])
    end

    def campaign_params
      params.require(:campaign).permit(:title, :description, :language, :target_area, :target_village, :target_support_status, :scheduled_at, :campaign_status, :image_url)
    end

    def serialize(campaign)
      campaign.as_json.merge(
        image_url: campaign.display_image_url,
        has_uploaded_image: campaign.uploaded_image.attached?
      )
    end
  end
end

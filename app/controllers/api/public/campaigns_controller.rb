module Api
  module Public
    class CampaignsController < ApplicationController
      def index
        campaigns = Campaign.where(campaign_status: [:scheduled, :active, :completed])
                            .order(Arel.sql("COALESCE(scheduled_at, created_at) DESC"))
        render json: campaigns.map { |c| serialize(c) }
      end

      def show
        campaign = Campaign.find(params[:id])
        render json: serialize(campaign)
      end

      private

      def serialize(campaign)
        {
          id: campaign.id,
          title: campaign.title,
          description: campaign.description,
          campaign_status: campaign.campaign_status,
          target_area: campaign.target_area,
          target_village: campaign.target_village,
          scheduled_at: campaign.scheduled_at,
          created_at: campaign.created_at,
          image_url: campaign.display_image_url
        }
      end
    end
  end
end
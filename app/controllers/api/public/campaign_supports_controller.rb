class Api::Public::CampaignSupportsController < ApplicationController
  def create
    support = CampaignSupport.new(support_params)
    if support.save
      render json: { success: true, message: "समर्थन सफलतापूर्वक दर्ज हुआ" }, status: :created
    else
      render json: { errors: support.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def support_params
    params.require(:campaign_support).permit(:campaign_id, :name, :phone_number, :area, :village_or_ward, :message)
  end
end

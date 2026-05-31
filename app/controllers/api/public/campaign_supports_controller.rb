class Api::Public::CampaignSupportsController < ApplicationController
  def create
    phone = params.require(:campaign_support).require(:phone_number)

    otp_record = MobileOtpVerification.where(phone_number: phone, purpose: "campaign_support")
                                       .where.not(verified_at: nil)
                                       .order(created_at: :desc)
                                       .first

    unless otp_record
      return render json: { error: "पहले OTP सत्यापित करें" }, status: :unprocessable_entity
    end

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

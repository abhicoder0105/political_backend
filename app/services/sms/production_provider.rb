class Sms::ProductionProvider < Sms::BaseProvider
  def send(phone_number, message)
    api_key = ENV["SMS_API_KEY"]
    sender_id = ENV["SMS_SENDER_ID"]
    template_id = ENV["SMS_TEMPLATE_ID"]

    unless api_key && sender_id
      Rails.logger.warn "[SMS-PROD] No SMS_API_KEY or SMS_SENDER_ID configured. Logging instead."
      Rails.logger.info "[SMS-PROD] To: #{phone_number} | #{message}"
      return
    end

    # Placeholder for Indian SMS gateway integration.
    # Replace with actual API call:
    #   provider = ENV.fetch("SMS_PROVIDER", "msg91")
    #   case provider
    #   when "msg91"
    #     # Msg91 API call
    #   when "twilio"
    #     # Twilio API call
    #   end
    Rails.logger.info "[SMS-PROD] To: #{phone_number} via #{ENV.fetch("SMS_PROVIDER", "default")} | #{message}"
  end
end

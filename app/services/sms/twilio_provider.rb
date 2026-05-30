class Sms::TwilioProvider < Sms::BaseProvider
  def send(phone_number, message)
    # Placeholder for Twilio or Indian SMS gateway
    # client = Twilio::REST::Client.new(ENV['TWILIO_SID'], ENV['TWILIO_AUTH_TOKEN'])
    # client.messages.create(from: ENV['TWILIO_PHONE'], to: "+91#{phone_number}", body: message)
    Rails.logger.info "[SMS-PROD] To: #{phone_number} | #{message}"
  end
end

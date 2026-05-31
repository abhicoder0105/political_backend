class Sms::DevelopmentProvider < Sms::BaseProvider
  def send(phone_number, message)
    Rails.logger.info "[SMS] To: #{phone_number} | #{message}"
    puts "[SMS] To: #{phone_number} | #{message}"
  end
end

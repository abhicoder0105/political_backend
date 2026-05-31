class SmsProviderResolver
  def self.resolve
    provider_name = ENV.fetch("SMS_PROVIDER", "development").downcase

    case provider_name
    when "production", "twilio", "msg91"
      Sms::ProductionProvider.new
    else
      Sms::DevelopmentProvider.new
    end
  end
end

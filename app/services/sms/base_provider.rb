class Sms::BaseProvider
  def send(phone_number, message)
    raise NotImplementedError
  end
end

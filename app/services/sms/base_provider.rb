class Sms::BaseProvider
  def send(phone_number, message)
    raise NotImplementedError
  end

  def send_otp(phone_number, otp)
    message = "आपका OTP कोड है: #{otp}. यह 5 मिनट के लिए वैध है।"
    send(phone_number, message)
  end
end

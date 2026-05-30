module JsonWebToken
  extend ActiveSupport::Concern

  included do
    attr_reader :current_jwt_payload
  end

  def jwt_encode(payload = {}, expires_at: Rails.application.config.x.jwt.expires_in.seconds.from_now, **claims)
    payload = payload.merge(claims)
    payload = payload.merge(
      exp: expires_at.to_i,
      iss: Rails.application.config.x.jwt.issuer
    )

    JWT.encode(payload, jwt_secret, Rails.application.config.x.jwt.algorithm)
  end

  def jwt_decode(token)
    decoded_token, = JWT.decode(
      token,
      jwt_secret,
      true,
      {
        algorithm: Rails.application.config.x.jwt.algorithm,
        iss: Rails.application.config.x.jwt.issuer,
        verify_iss: true
      }
    )

    decoded_token.with_indifferent_access
  end

  def authenticate_request!
    token = bearer_token
    raise JWT::DecodeError, "Missing bearer token" if token.blank?

    @current_jwt_payload = jwt_decode(token)
  rescue JWT::DecodeError
    render json: { error: "Unauthorized" }, status: :unauthorized
  end

  private

  def bearer_token
    request.authorization.to_s[/\ABearer (.+)\z/, 1]
  end

  def jwt_secret
    Rails.application.config.x.jwt.secret
  end
end

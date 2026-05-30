Rails.application.config.x.jwt.algorithm = "HS256"
Rails.application.config.x.jwt.issuer = ENV.fetch("JWT_ISSUER", "political_app")
Rails.application.config.x.jwt.secret = ENV.fetch("JWT_SECRET_KEY") { Rails.application.secret_key_base }
Rails.application.config.x.jwt.expires_in = ENV.fetch("JWT_EXPIRES_IN", 24.hours).to_i

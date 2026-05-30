frontend_origins = [
  ENV.fetch("FRONTEND_ORIGIN", "http://localhost:5173"),
  "http://localhost:5174",
  "http://localhost:5175",
  "http://127.0.0.1:5174",
  "http://127.0.0.1:5175"
]

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins frontend_origins

    resource "*",
      headers: :any,
      methods: %i[get post put patch delete options head],
      expose: %w[Authorization],
      max_age: 600
  end
end

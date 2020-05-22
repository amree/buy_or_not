Goodreads.configure(
  api_key: Rails.application.credentials.goodreads[:key],
  api_secret: Rails.application.credentials.goodreads[:secret]
)

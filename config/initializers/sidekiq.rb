require "sidekiq"

sidekiq_config = {
  namespace: "buy_or_not",
  url: Rails.application.credentials.redis_url
}

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end

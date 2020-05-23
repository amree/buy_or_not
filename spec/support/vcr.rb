require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = "spec/cassettes"
  c.hook_into :webmock
  c.ignore_localhost = true
  c.configure_rspec_metadata!
  c.allow_http_connections_when_no_cassette = true
  c.default_cassette_options = {
    record: :new_episodes
  }
  c.filter_sensitive_data("GOODREADS_KEY") do
    Rails.application.credentials.goodreads[:key]
  end
  c.filter_sensitive_data("FACEBOOK_APP_SECRET") do
    Rails.application.credentials.facebook[:app_secret]
  end
  c.filter_sensitive_data("FACEBOOK_ACCESS_TOKEN") do
    Rails.application.credentials.facebook[:access_token]
  end
  c.filter_sensitive_data("WATSON_NLP_IAM_APIKEY") do
    Rails.application.credentials.watson_nlp[:iam_apikey]
  end
  c.filter_sensitive_data("WATSON_NLP_URL") do
    Rails.application.credentials.watson_nlp[:url]
  end
end

unless Rails.env.production?
  bot_files = Dir[Rails.root.join("app", "bot", "**", "*.rb")]

  bot_reloader = ActiveSupport::FileUpdateChecker.new(bot_files) {
    bot_files.each { |file| require_dependency file }
  }

  ActiveSupport::Reloader.to_prepare do
    bot_reloader.execute_if_updated
  end

  bot_files.each { |file| require_dependency file }
end


class FacebookMessengerProvider < Facebook::Messenger::Configuration::Providers::Base
  # Verify that the given verify token is valid.
  #
  # verify_token - A String describing the application's verify token.
  #
  # Returns a Boolean representing whether the verify token is valid.
  def valid_verify_token?(verify_token)
    Rails.application.credentials.facebook[:verify_token] == verify_token
  end

  # Find the right application secret.
  #
  # page_id - An Integer describing a Facebook Page ID.
  #
  # Returns a String describing the application secret.
  def app_secret_for(page_id)
    Rails.application.credentials.facebook[:app_secret]
  end

  # Find the right access token.
  #
  # recipient - A Hash describing the `recipient` attribute of the message coming
  #             from Facebook.
  #
  # Note: The naming of "recipient" can throw you off, but think of it from the
  # perspective of the message: The "recipient" is the page that receives the
  # message.
  #
  # Returns a String describing an access token.
  def access_token_for(recipient)
    Rails.application.credentials.facebook[:access_token]
  end

  private

  def bot
    BuyOrNot::Bot
  end
end

Facebook::Messenger.configure do |config|
  config.provider = FacebookMessengerProvider.new
end

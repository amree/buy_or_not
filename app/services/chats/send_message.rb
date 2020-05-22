module Chats
  class SendMessage
    include Callable

    def initialize(sender_id:, template:, next_state:)
      @sender_id = sender_id
      @template = template
      @next_state = next_state
    end

    def call
      send_message
      update_state
    end

    private

    attr_reader(
      :sender_id,
      :next_state,
      :template
    )

    def send_message
      access_token = Rails.application.credentials.facebook[:access_token]

      Facebook::Messenger::Bot.deliver({
        recipient: {id: sender_id},
        message: template,
        messaging_type: Facebook::Messenger::Bot::MessagingType::UPDATE
      }, access_token: access_token)
    end

    def update_state
      return if next_state.nil?

      Chatter
        .find_by(facebook_sender_id: sender_id)
        .update(state: next_state)
    end
  end
end

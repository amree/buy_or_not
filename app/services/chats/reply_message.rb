module Chats
  class ReplyMessage
    def initialize(message:, template:, next_state:)
      @message = message
      @template = template
      @next_state = next_state
    end

    def self.call(*args)
      new(*args).call
    end

    def call
      reply_message
      update_state
    end

    private

    attr_reader(
      :message,
      :template,
      :next_state
    )

    def reply_message
      message.reply(template)
    end

    def update_state
      return if next_state.nil?

      Chatter
        .find_by(facebook_sender_id: message.sender["id"])
        .update(state: next_state)
    end
  end
end

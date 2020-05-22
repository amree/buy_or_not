module Chats
  class HandleMessage
    include Callable
    include MessageTemplates::SearchType
    include MessageTemplates::SimpleMessages

    def initialize(message:)
      @message = message
    end

    def call
      update_chatter_state

      case chatter.state
      when "initial"
        send_initial_message
      when "waiting_for_type_name_input"
        perform_search(searcher: GoodReads::SearchByName)
      when "waiting_for_type_id_input"
        perform_search(searcher: GoodReads::SearchById)
      when "searching"
        Chats::ReplyMessage.call(message: message, template: searching_template)
      when "processing"
        Chats::ReplyMessage.call(message: message, template: processing_template)
      end
    end

    private

    attr_reader(
      :chatter,
      :message
    )

    def update_chatter_state
      @chatter = Chatter.find_or_create_by(
        facebook_sender_id: message.sender["id"]
      )
      @chatter.update(state: "initial") if @chatter.state.nil?
    end

    def send_initial_message
      Chats::ReplyMessage.call(
        message: message,
        template: ask_for_type_of_search,
        next_state: "waiting_for_type_input"
      )
    end

    def perform_search(searcher:)
      GoodReads::SearchBookJob.perform_later(
        search_key: message.text,
        recipient_id: chatter.facebook_sender_id,
        searcher: searcher.to_s
      )

      chatter.update(state: "searching")
    end
  end
end

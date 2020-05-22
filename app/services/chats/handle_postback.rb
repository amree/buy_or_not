module Chats
  class HandlePostback
    include MessageTemplates::SimpleMessages

    def initialize(postback:)
      @postback = postback
    end

    def self.call(*args)
      new(*args).call
    end

    def call
      type, book_id = postback.payload.split("__")

      case type
      when "SEARCH_BY_NAME"
        search_by_name
      when "SEARCH_BY_GOOD_READS_ID"
        search_by_id
      when "SELECT_BOOK"
        select_book(book_id)
      end
    end

    private

    attr_reader :postback

    def sender_id
      postback.sender["id"]
    end

    def search_by_name
      Chats::SendMessage.call(
        sender_id: sender_id,
        template: enter_book_name_template,
        next_state: "waiting_for_type_name_input"
      )
    end

    def search_by_id
      Chats::SendMessage.call(
        sender_id: sender_id,
        template: enter_book_id_template,
        next_state: "waiting_for_type_id_input"
      )
    end

    def select_book(book_id)
      Chats::SendMessage.call(
        sender_id: postback.sender["id"],
        template: processing_template,
        next_state: "processing"
      )
      Chats::GetBookRecommendationJob.perform_later(
        book_id: book_id,
        facebook_sender_id: sender_id
      )
    end
  end
end

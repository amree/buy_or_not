module GoodReads
  class HandleSearch
    include GoodReadsClient
    include Chats::MessageTemplates::BookSelections
    include Chats::MessageTemplates::SimpleMessages

    def initialize(search_key:, recipient_id:, searcher:)
      @search_key = search_key
      @recipient_id = recipient_id
      @searcher = searcher
    end

    def self.call(*args)
      new(*args).call
    end

    def call
      @result = searcher.call(search_key: search_key)

      if result.is_a? Array
        handle_result_by_name
      else
        handle_result_by_id
      end
    rescue Goodreads::NotFound
      handle_not_found
    rescue
      handle_error
    end

    private

    attr_reader(
      :search_key,
      :recipient_id,
      :result,
      :searcher
    )

    def handle_result_by_name
      Chats::SendMessage.call(
        sender_id: recipient_id,
        template: select_books_template(result),
        next_state: "waiting_for_book_selections"
      )
    end

    def handle_result_by_id
      Chats::GetBookRecommendationJob.perform_later(
        book_id: result.id,
        facebook_sender_id: recipient_id
      )
      Chats::SendMessage.call(
        sender_id: recipient_id,
        template: processing_template,
        next_state: "processing"
      )
    end

    def handle_not_found
      Chats::SendMessage.call(
        sender_id: recipient_id,
        template: not_found_template,
        next_state: "initial"
      )
    end

    def handle_error
      Chats::SendMessage.call(
        sender_id: recipient_id,
        template: error_template,
        next_state: "initial"
      )
    end
  end
end

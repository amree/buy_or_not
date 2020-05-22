module Chats
  class GetBookRecommendation
    include Callable
    include MessageTemplates::SimpleMessages

    def initialize(book_id:, facebook_sender_id:)
      @book_id = book_id
      @facebook_sender_id = facebook_sender_id
    end

    def call
      get_review_ids
      get_reviews
      get_sentiment
      make_decision
    end

    private

    attr_reader(
      :book_id,
      :book_ids,
      :facebook_sender_id,
      :good_sentiment,
      :reviews
    )

    def get_review_ids
      @book_ids = GoodReads::GetReviewIds.call(book_id: book_id)
    end

    def get_reviews
      @reviews = GoodReads::GetReviews.call(book_ids: book_ids)
    end

    def get_sentiment
      @good_sentiment = Watson::SentimentAnalysis.call(texts: reviews)
    end

    def make_decision
      Chats::SendMessage.call(
        sender_id: facebook_sender_id,
        template: message_template,
        next_state: "initial"
      )
    end

    def message_template
      good_sentiment ? recommend_buy_template : not_recommend_buy_template
    end
  end
end

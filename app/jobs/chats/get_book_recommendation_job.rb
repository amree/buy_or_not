module Chats
  class GetBookRecommendationJob < ApplicationJob
    def perform(book_id:, facebook_sender_id:)
      Chats::GetBookRecommendation.call(
        book_id: book_id,
        facebook_sender_id: facebook_sender_id
      )
    end
  end
end

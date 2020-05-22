module GoodReads
  class GetReviews
    include Callable
    include GoodReadsClient

    def initialize(book_ids:)
      @book_ids = book_ids
    end

    def call
      book_ids.map { |id| client.review(id).body.strip }
    end

    private

    attr_reader :book_ids
  end
end

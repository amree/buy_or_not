module GoodReads
  class GetReviews
    include GoodReadsClient

    def initialize(book_ids:)
      @book_ids = book_ids
    end

    def self.call(*args)
      new(*args).call
    end

    def call
      book_ids.map { |id| client.review(id).body.strip }
    end

    private

    attr_reader :book_ids
  end
end

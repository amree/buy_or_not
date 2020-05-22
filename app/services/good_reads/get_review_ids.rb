require "open-uri"

module GoodReads
  class GetReviewIds
    include Callable
    include GoodReadsClient

    def initialize(book_id:)
      @book_id = book_id
    end

    def call
      get_book
      get_reviews_widget
      get_review_page
      get_review_ids
    end

    private

    attr_reader(
      :book_id,
      :book,
      :review_page,
      :widget
    )

    def get_book
      @book = client.book(book_id)
    end

    def get_reviews_widget
      @widget = Nokogiri::HTML.parse(book.reviews_widget)
    end

    def get_review_page
      url = widget.css("#the_iframe").attribute("src").value

      # rubocop:disable Security/Open
      @review_page = Nokogiri::HTML.parse(open(url).read)
      # rubocop:enable Security/Open
    end

    def get_review_ids
      review_page.css(".gr_more_link").map { |review|
        parse_review_id(review.attribute("href").value)
      }
    end

    def parse_review_id(link)
      link
        .gsub("https://www.goodreads.com/review/show/", "")
        .split("?")
        .first
    end
  end
end

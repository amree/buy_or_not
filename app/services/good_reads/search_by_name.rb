module GoodReads
  class SearchByName
    include Callable
    include GoodReadsClient

    def initialize(search_key:)
      @search_key = search_key
    end

    def call
      search_by_title
      parse_result
    end

    private

    attr_reader(
      :output,
      :search_key
    )

    def search_by_title
      @output = client.search_books(search_key, field: "title")

      raise GoodReads::NotFound if output["total_results"] == 0
    end

    def parse_result
      output
        .results
        .work
        .take(5)
        .map do |book|
          {
            id: book["best_book"]["id"],
            title: book["best_book"]["title"],
            image_url: book["best_book"]["image_url"]
          }
        end
    end
  end
end

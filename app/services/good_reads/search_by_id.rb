module GoodReads
  class SearchById
    include GoodReadsClient

    def initialize(search_key:)
      @search_key = search_key
    end

    def self.call(*args)
      new(*args).call
    end

    def call
      client.book(search_key)
    end

    private

    attr_reader :search_key
  end
end

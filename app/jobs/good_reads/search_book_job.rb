module GoodReads
  class SearchBookJob < ApplicationJob
    def perform(search_key:, recipient_id:, searcher:)
      GoodReads::HandleSearch.call(
        search_key: search_key,
        recipient_id: recipient_id,
        searcher: searcher.constantize
      )
    end
  end
end

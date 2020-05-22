module GoodReads
  module GoodReadsClient
    def client
      @client ||= Goodreads::Client.new
    end
  end
end

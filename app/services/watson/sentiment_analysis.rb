module Watson
  class SentimentAnalysis
    def initialize(texts:)
      @texts = texts
    end

    def self.call(*args)
      new(*args).call
    end

    def call
      results = texts.map { |text|
        nlp
          .analyze(
            text: text,
            features: {sentiment: {}},
            language: "en"
          )
          .result
          .dig(
            "sentiment",
            "document",
            "label"
          )
      }

      results.count("positive") >= results.count("negative")
    end

    private

    attr_reader :texts

    def authenticator
      @authenticator ||= IBMWatson::Authenticators::IamAuthenticator.new(
        apikey: Rails.application.credentials.watson_nlp[:iam_apikey]
      )
    end

    def nlp
      return @nlp if instance_variable_defined?("@nlp")

      @nlp = IBMWatson::NaturalLanguageUnderstandingV1.new(
        authenticator: authenticator,
        version: "2019-07-12"
      )

      @nlp.service_url = Rails.application.credentials.watson_nlp[:url]
      @nlp
    end
  end
end

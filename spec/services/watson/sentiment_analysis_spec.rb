RSpec.describe Watson::SentimentAnalysis, vcr: true do
  subject { described_class.call(texts: texts) }

  context "with positive sentiments" do
    let(:texts) { ["i love this book", "love everything about this"] }

    it { is_expected.to eql(true) }
  end

  context "with negative sentiments" do
    let(:texts) { ["i hate this book", "i don't like it"] }

    it { is_expected.to eql(false) }
  end

  context "when positive and negative sentiments are equals" do
    let(:texts) { ["i hate this book", "i love this book"] }

    it { is_expected.to eql(true) }
  end
end

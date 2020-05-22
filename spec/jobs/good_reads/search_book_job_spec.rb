Sidekiq::Testing.inline!

RSpec.describe GoodReads::SearchBookJob do
  let(:search_key) { 123 }
  let(:recipient_id) { 456 }
  let(:searcher) { GoodReads::SearchByName }

  before do
    expect(GoodReads::HandleSearch).to receive(:call).with(
      search_key: search_key,
      recipient_id: recipient_id,
      searcher: searcher
    )
  end

  it do
    described_class.perform_later(
      search_key: search_key,
      recipient_id: recipient_id,
      searcher: searcher.to_s
    )
  end
end

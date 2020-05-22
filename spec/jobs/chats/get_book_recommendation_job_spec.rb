Sidekiq::Testing.inline!

RSpec.describe Chats::GetBookRecommendationJob do
  let(:book_id) { 123 }
  let(:facebook_sender_id) { 456 }

  before do
    expect(Chats::GetBookRecommendation).to receive(:call).with(
      book_id: book_id,
      facebook_sender_id: facebook_sender_id
    )
  end

  it do
    described_class.perform_later(
      book_id: book_id,
      facebook_sender_id: facebook_sender_id
    )
  end
end

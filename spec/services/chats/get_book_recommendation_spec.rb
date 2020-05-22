RSpec.describe Chats::GetBookRecommendation, vcr: true do
  let(:chatter) { create(:chatter, facebook_sender_id: 3293340114019303) }
  let(:facebook_sender_id) { chatter.facebook_sender_id }

  subject do
    described_class.call(
      book_id: book_id, facebook_sender_id: facebook_sender_id
    )
  end

  context "with positive sentimenets" do
    let(:book_id) { 17853143 }

    before do
      message_template =
        Class
          .new
          .extend(Chats::MessageTemplates::SimpleMessages)
          .recommend_buy_template

      expect(Chats::SendMessage).to receive(:call).with(
        sender_id: facebook_sender_id,
        template: message_template,
        next_state: "initial"
      )
    end

    it { subject }
  end

  context "with negative sentimenets" do
    let(:book_id) { 6732019 }

    before do
      message_template =
        Class
          .new
          .extend(Chats::MessageTemplates::SimpleMessages)
          .not_recommend_buy_template

      expect(Chats::SendMessage).to receive(:call).with(
        sender_id: facebook_sender_id,
        template: message_template,
        next_state: "initial"
      )
    end

    it { subject }
  end
end

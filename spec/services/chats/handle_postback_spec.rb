RSpec.describe Chats::HandlePostback do
  FakePostback = Struct.new(:payload) {
    def sender
      {"id" => "3293340114019303"}
    end
  }

  let(:postback) { FakePostback.new(payload) }

  subject { described_class.call(postback: postback) }

  context "when type is SEARCH_BY_NAME" do
    let(:payload) { "SEARCH_BY_NAME" }

    before do
      expect(Chats::SendMessage).to receive(:call).with(
        sender_id: "3293340114019303",
        template: read_template("SimpleMessages").enter_book_name_template,
        next_state: "waiting_for_type_name_input"
      )
    end

    it { subject }
  end

  context "when type is SEARCH_BY_GOOD_READS_ID" do
    let(:payload) { "SEARCH_BY_GOOD_READS_ID" }

    before do
      expect(Chats::SendMessage).to receive(:call).with(
        sender_id: "3293340114019303",
        template: read_template("SimpleMessages").enter_book_id_template,
        next_state: "waiting_for_type_id_input"
      )
    end

    it { subject }
  end

  context "when type is SELECT_BOOK" do
    let(:payload) { "SELECT_BOOK__123" }

    before do
      expect(Chats::SendMessage).to receive(:call).with(
        sender_id: postback.sender["id"],
        template: read_template("SimpleMessages").processing_template,
        next_state: "processing"
      )

      expect(Chats::GetBookRecommendationJob).to receive(:perform_later).with(
        book_id: "123",
        facebook_sender_id: postback.sender["id"]
      )
    end

    it { subject }
  end
end

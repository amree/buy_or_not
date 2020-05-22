RSpec.describe Chats::HandleMessage do
  FakeMessage = Struct.new(:sender, :text) {
    def reply(template)
    end
  }
  let(:facebook_id) { "3293340114019303" }
  let(:message) { FakeMessage.new({"id" => facebook_id}, "rework") }

  subject { described_class.call(message: message) }

  context "when user send message for the first time" do
    before do
      expect(Chats::ReplyMessage).to receive(:call).with(
        message: message,
        template: read_template("SearchType").ask_for_type_of_search,
        next_state: "waiting_for_type_input"
      )
    end

    it do
      subject

      expect(Chatter.last.state).to eql("initial")
      expect(Chatter.last.facebook_sender_id).to eql(facebook_id)
    end
  end

  context "when state waiting_for_type_name_input" do
    let(:chatter) do
      create(
        :chatter,
        facebook_sender_id: facebook_id,
        state: "waiting_for_type_name_input"
      )
    end

    before do
      expect(GoodReads::SearchBookJob).to receive(:perform_later).with(
        search_key: message.text,
        recipient_id: chatter.facebook_sender_id,
        searcher: "GoodReads::SearchByName"
      )
    end

    it do
      subject

      expect(Chatter.last.state).to eql("searching")
    end
  end

  context "when state waiting_for_type_id_input" do
    let(:chatter) do
      create(
        :chatter,
        facebook_sender_id: facebook_id,
        state: "waiting_for_type_id_input"
      )
    end

    before do
      expect(GoodReads::SearchBookJob).to receive(:perform_later).with(
        search_key: message.text,
        recipient_id: chatter.facebook_sender_id,
        searcher: "GoodReads::SearchById"
      )
    end

    it do
      subject

      expect(Chatter.last.state).to eql("searching")
    end
  end

  context "searching" do
    let!(:chatter) do
      create(
        :chatter,
        facebook_sender_id: facebook_id,
        state: "searching"
      )
    end

    before do
      expect(Chats::ReplyMessage).to(
        receive(:call)
          .with(
            message: message,
            template: read_template("SimpleMessages").searching_template
          )
      )
    end

    it { subject }
  end

  context "processing" do
    let!(:chatter) do
      create(
        :chatter,
        facebook_sender_id: facebook_id,
        state: "processing"
      )
    end

    before do
      expect(Chats::ReplyMessage).to(
        receive(:call)
        .with(
          message: message,
          template: read_template("SimpleMessages").processing_template
        )
      )
    end

    it { subject }
  end

  context "when user send second message" do
    let!(:chatter) do
      create(
        :chatter,
        facebook_sender_id: facebook_id,
        state: "initial"
      )
    end

    before do
      expect(Chats::ReplyMessage).to receive(:call).with(
        message: message,
        template: read_template("SearchType").ask_for_type_of_search,
        next_state: "waiting_for_type_input"
      )
    end

    it do
      subject

      expect(Chatter.count).to eql(1)
    end
  end
end

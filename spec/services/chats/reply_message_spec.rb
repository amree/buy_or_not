RSpec.describe Chats::ReplyMessage do
  FakeReplyMessage = Struct.new(:sender) {
    def reply(template)
    end
  }

  let(:chatter) { create(:chatter) }
  let(:message) { FakeReplyMessage.new({"id" => chatter.facebook_sender_id}) }
  let(:sender_id) { chatter.facebook_sender_id }
  let(:template) { {text: "Hello"} }

  subject do
    described_class.call(
      message: message,
      template: template,
      next_state: next_state
    )
  end

  before do
    expect(message).to receive(:reply).with(template)

    subject
  end

  context "with next state" do
    let(:next_state) { "processing" }

    it { expect(chatter.reload.state).to eql(next_state) }
  end

  context "without next state" do
    let(:next_state) { nil }

    it { expect(chatter.reload.state).to eql("initial") }
  end
end

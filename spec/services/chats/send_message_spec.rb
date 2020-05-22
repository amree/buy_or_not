RSpec.describe Chats::SendMessage, vcr: true do
  let(:access_token) { Rails.application.credentials.facebook[:access_token] }
  let(:chatter) { create(:chatter) }
  let(:sender_id) { chatter.facebook_sender_id }
  let(:template) { {text: "Hello"} }

  subject do
    described_class.call(
      sender_id: sender_id,
      template: template,
      next_state: next_state
    )
  end

  before do
    expect(Facebook::Messenger::Bot).to receive(:deliver).with(
      {
        recipient: {id: sender_id},
        message: template,
        messaging_type: Facebook::Messenger::Bot::MessagingType::UPDATE
      }, access_token: access_token
    )

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

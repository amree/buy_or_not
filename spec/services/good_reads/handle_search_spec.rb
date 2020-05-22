Sidekiq::Testing.inline!

RSpec.describe GoodReads::HandleSearch, vcr: true do
  let(:chatter) { create(:chatter, facebook_sender_id: "3293340114019303") }
  let(:recipient_id) { chatter.facebook_sender_id }

  subject do
    GoodReads::HandleSearch.call(
      search_key: search_key,
      recipient_id: recipient_id,
      searcher: searcher
    )
  end

  context "search by name" do
    let(:template) do
      read_template("BookSelections").select_books_template(searcher_result)
    end
    let(:search_key) { "rework" }
    let(:searcher) { GoodReads::SearchByName }
    let(:searcher_result) do
      [
        {
          id: 123,
          title: "Rework",
          image_url: "https://image.png"
        }
      ]
    end

    before do
      expect(searcher).to(
        receive(:call).with(search_key: search_key).and_return(searcher_result)
      )
      expect(Chats::SendMessage).to receive(:call).with(
        sender_id: recipient_id,
        template: template,
        next_state: "waiting_for_book_selections"
      )
    end

    it "sent the correct message and update state" do
      subject
    end
  end

  context "search by id" do
    let(:template) { read_template("SimpleMessages").processing_template }
    let(:search_key) { 17853143 }
    let(:searcher) { GoodReads::SearchById }
    let(:searcher_result) do
      OpenStruct.new(
        id: search_key,
        title: "Rework",
        image_url: "https://image.png"
      )
    end

    before do
      expect(searcher).to(
        receive(:call).with(search_key: search_key).and_return(searcher_result)
      )
      expect(Chats::GetBookRecommendationJob).to receive(:perform_later).with(
        book_id: searcher_result[:id],
        facebook_sender_id: recipient_id
      )
      expect(Chats::SendMessage).to receive(:call).with(
        sender_id: recipient_id,
        template: template,
        next_state: "processing"
      )
    end

    it "sent the correct message and update state" do
      subject
    end
  end

  context "when book not found" do
    let(:template) { read_template("SimpleMessages").not_found_template }
    let(:search_key) { 17853143 }
    let(:searcher) { GoodReads::SearchById }

    before do
      expect(GoodReads::SearchById).to receive(:call).and_raise(Goodreads::NotFound)
      expect(Chats::SendMessage).to receive(:call).with(
        sender_id: recipient_id,
        template: template,
        next_state: "initial"
      ).and_call_original
    end

    it "sent the correct message and update state" do
      subject
    end
  end

  context "when unexpected error happened" do
    let(:template) { read_template("SimpleMessages").error_template }
    let(:search_key) { 17853143 }
    let(:searcher) { GoodReads::SearchById }

    before do
      expect(GoodReads::SearchById).to receive(:call).and_raise(StandardError)
      expect(Chats::SendMessage).to receive(:call).with(
        sender_id: recipient_id,
        template: template,
        next_state: "initial"
      ).and_call_original
    end

    it "sent the correct message and update state" do
      subject
    end
  end
end

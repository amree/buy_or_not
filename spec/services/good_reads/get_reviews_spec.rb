RSpec.describe GoodReads::GetReviews, vcr: true do
  subject { described_class.call(book_ids: book_ids) }

  context "with valid ids" do
    let(:book_ids) { ["1915387742"] }

    it "returns array of goodreads reviews" do
      expect(subject).to eql(["good book!"])
    end
  end

  context "with invalid id" do
    let(:book_ids) { ["abc"] }

    it "throws an exception " do
      expect { subject }.to raise_error(Goodreads::NotFound)
    end
  end
end

RSpec.describe GoodReads::GetReviewIds, vcr: true do
  subject { described_class.call(book_id: book_id) }

  context "with valid id" do
    let(:book_id) { 123 }

    it "returns array of goodreads book id" do
      expect(subject).to eql([
        "1915387742",
        "191145107",
        "2290562374",
        "874310980",
        "2690172007",
        "704291",
        "565207204",
        "753539495",
        "612044343",
        "2144509435"
      ])
    end
  end

  context "with invalid id" do
    let(:book_id) { "abc" }

    it "throws an exception " do
      expect { subject }.to raise_error(Goodreads::NotFound)
    end
  end
end

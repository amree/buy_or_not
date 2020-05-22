RSpec.describe GoodReads::SearchById, vcr: true do
  let(:search_key) { 17853143 }

  subject { described_class.call(search_key: search_key) }

  it "returns the correct result" do
    expect(subject.id).to eql(search_key.to_s)
  end
end

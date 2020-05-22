RSpec.describe GoodReads::SearchByName, vcr: true do
  let(:search_key) { "rework" }

  subject { described_class.call(search_key: search_key) }

  it "returns the correct result" do
    result = [
      {
        id: 6732019,
        image_url: "https://s.gr-assets.com/assets/nophoto/book/111x148-bcc042a9c91a29c1d680899eff700a03.png",
        title: "Rework"
      },
      {
        id: 536170,
        image_url: "https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1309282796l/536170._SY160_.jpg",
        title: "I Ain't Got Time to Bleed: Reworking the Body Politic from the Bottom up"
      },
      {
        id: 18762178,
        image_url: "https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1384015941l/18762178._SX98_.jpg",
        title: "Robert Cantwell and the Literary Left: A Northwest Writer Reworks American Fiction"
      },
      {
        id: 197651,
        image_url: "https://s.gr-assets.com/assets/nophoto/book/111x148-bcc042a9c91a29c1d680899eff700a03.png",
        title: "Concrete and Clay: Reworking Nature in New York City"
      },
      {
        id: 36722625,
        image_url: "https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1541130153l/36722625._SX98_.jpg",
        title: "Critical Fabulations: Reworking the Methods and Margins of Design"
      }
    ]

    expect(subject).to eql(result)
  end
end

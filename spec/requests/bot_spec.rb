RSpec.describe "Bot", type: :request do
  context "message" do
    before do
      expect(Facebook::Messenger::Bot).to receive(:trigger).with(:message, any_args)
    end

    let :payload do
      JSON.generate(
        object: "page",
        entry: [
          {
            id: "1",
            time: 145_776_419_824_6,
            messaging: [
              {
                sender: {id: "2"},
                recipient: {id: "3"},
                timestamp: 145_776_419_762_7,
                message: {
                  mid: "mid.1457764197618:41d102a3e1ae206a38",
                  seq: 73,
                  text: "Hello, bot!"
                }
              }
            ]
          }
        ]
      )
    end

    it do
      signature = OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new("sha1"),
        Rails.application.credentials.facebook[:app_secret],
        payload
      )

      post "/bot", params: payload, headers: {"HTTP_X_HUB_SIGNATURE" => "sha1=#{signature}"}
    end
  end

  context "postback" do
    before do
      expect(Facebook::Messenger::Bot).to receive(:trigger).with(:postback, any_args)
    end

    let :payload do
      JSON.generate(
        {
          object: "page",
          entry: [
            {
              id: "100316455036764",
              time: 1590159372974,
              messaging: [
                {
                  sender: {id: "3293340114019303"},
                  recipient: {id: "100316455036764"},
                  timestamp: 1590159372363,
                  postback: {
                    title: "By GoodReads ID",
                    payload: "SEARCH_BY_GOOD_READS_ID"
                  }
                }
              ]
            }
          ]
        }
      )
    end

    it do
      signature = OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new("sha1"),
        Rails.application.credentials.facebook[:app_secret],
        payload
      )

      post "/bot", params: payload, headers: {"HTTP_X_HUB_SIGNATURE" => "sha1=#{signature}"}
    end
  end
end

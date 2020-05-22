RSpec.describe "Health", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/health"

      expect(response).to have_http_status(:success)
      expect(response.body).to eql("ok")
    end
  end
end

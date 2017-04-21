require "spec_helper"

describe OmniAuth::Strategies::BookingSync do
  before do
    OmniAuth.config.test_mode = true
  end

  after do
    OmniAuth.config.test_mode = false
  end

  let(:request) { double("Request", params: {}, cookies: {}, env: {}) }
  let(:options) { {} }

  let(:strategy) do
    OmniAuth::Strategies::BookingSync.new(nil, options).tap do |strategy|
      allow(strategy).to receive(:request) { request }
    end
  end

  it_should_behave_like "an oauth2 strategy"

  describe "#client" do
    it "returns the correct site" do
      expect(strategy.client.site).to eq "https://www.bookingsync.com/"
    end

    it "returns the correct authorization url" do
      expect(strategy.client.options[:authorize_url]).to eq "/oauth/authorize"
    end

    it "returns the correct token url" do
      expect(strategy.client.options[:token_url]).to eq "/oauth/token"
    end
  end

  describe "#callback_path" do
    it "returns the correct callback path" do
      expect(strategy.callback_path).to eq("/auth/bookingsync/callback")
    end
  end

  describe "#authorize_params" do
    it "passes account_id from request params" do
      request.params["account_id"] = "123"
      expect(strategy.authorize_params[:account_id]).to eq 123
    end

    it "passes _bookingsync_account_id from request params" do
      request.params["_bookingsync_account_id"] = "123"
      expect(strategy.authorize_params[:account_id]).to eq 123
    end

    it "passes _bookingsync_account_id and account_id from request params, " +
    "it use _bookingsync_account_id" do
      request.params["_bookingsync_account_id"] = "123"
      request.params["account_id"] = "456"
      expect(strategy.authorize_params[:account_id]).to eq 123
    end

    it "ignores blank params" do
      request.params["_bookingsync_account_id"] = ""
      request.params["account_id"] = "456"
      expect(strategy.authorize_params[:account_id]).to eq 456
    end

    it "ignores non numeric params" do
      request.params["_bookingsync_account_id"] = "a"
      request.params["account_id"] = "b"
      expect(strategy.authorize_params[:account_id]).to be_nil
    end
  end

  describe "#raw_info" do
    let(:body) { '{"accounts": [{"id": 1}]}' }
    let(:response) { double("response", headers: headers, status: 200, body: body) }

    before do
      allow(strategy).to receive(:access_token).and_return(double)
      expect(strategy.access_token).to receive(:get).with("/api/v3/accounts")
        .and_return(OAuth2::Response.new(response))
    end

    context "when Content-Type not supported" do
      let(:headers) { { "Content-Type" => "application/foo-bar" } }

      it "raises a NoMethodError error" do
        expect { strategy.raw_info }.to raise_error(NoMethodError)
      end
    end

    context "when using JSONAPI Content-Type" do
      let(:headers) { { "Content-Type" => "application/vnd.api+json" } }

      it "returns account info from api v3" do
        expect(strategy.raw_info).to eq({ "id" => 1 })
      end
    end

    context "when using JSON Content-Type" do
      let(:headers) { { "Content-Type" => "application/json" } }

      it "returns account info from api v3" do
        expect(strategy.raw_info).to eq({ "id" => 1 })
      end
    end
  end

  describe "#callback_url" do
    let(:url_base) { "https://auth.example.com" }

    before do
      allow(request).to receive(:scheme).and_return("https")
      allow(request).to receive(:url).and_return("#{url_base}/some/page?foo=bar")

      allow(strategy).to receive(:script_name).and_return("") # as not to depend on Rack env
      allow(strategy).to receive(:query_string).and_return("?foo=bar")
    end

    it "returns default callback url (omitting querystring)" do
      expect(strategy.callback_url).to eq "#{url_base}/auth/bookingsync/callback"
    end

    context "with custom callback path" do
      let(:options) { { callback_path: "/auth/bookingsync/done" } }

      it "returns default callback url (omitting querystring)" do
        expect(strategy.callback_url).to eq "#{url_base}/auth/bookingsync/done"
      end
    end

    context "with custom callback url" do
      let(:url) { "https://auth.myapp.com/auth/bookingsync/callback" }
      let(:options) { { redirect_uri: url } }

      it "returns url from redirect_uri option" do
        expect(strategy.callback_url).to eq url
      end
    end
  end
end

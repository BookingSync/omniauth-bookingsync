require "spec_helper"

describe OmniAuth::Strategies::BookingSync do
  before do
    OmniAuth.config.test_mode = true
  end

  let(:request) { double("Request", params: {}, cookies: {}, env: {}) }
  let(:options) { {} }

  subject do
    OmniAuth::Strategies::BookingSync.new(nil, options).tap do |strategy|
      allow(strategy).to receive(:request) { request }
    end
  end

  it_should_behave_like "an oauth2 strategy"

  describe '#client' do
    it "has the correct site" do
      expect(subject.client.site).to eq("https://www.bookingsync.com/")
    end

    it "has the correct authorization url" do
      expect(subject.client.options[:authorize_url]).to eq("/oauth/authorize")
    end

    it "has the correct token url" do
      expect(subject.client.options[:token_url]).to eq("/oauth/token")
    end
  end

  describe '#callback_path' do
    it "has the correct callback path" do
      expect(subject.callback_path).to eq("/auth/bookingsync/callback")
    end
  end

  describe '#authorize_params' do
    it "passes account_id from request params" do
      request.params["account_id"] = "123"
      expect(subject.authorize_params[:account_id]).to eq 123
    end

    it "passes _bookingsync_account_id from request params" do
      request.params["_bookingsync_account_id"] = "123"
      expect(subject.authorize_params[:account_id]).to eq 123
    end

    it "passes _bookingsync_account_id and account_id from request params, " +
    "it use _bookingsync_account_id" do
      request.params["_bookingsync_account_id"] = "123"
      request.params["account_id"] = "456"
      expect(subject.authorize_params[:account_id]).to eq 123
    end

    it "ignores blank params" do
      request.params["_bookingsync_account_id"] = ""
      request.params["account_id"] = "456"
      expect(subject.authorize_params[:account_id]).to eq 456
    end

    it "ignores non numeric params" do
      request.params["_bookingsync_account_id"] = "a"
      request.params["account_id"] = "b"
      expect(subject.authorize_params[:account_id]).to be_nil
    end
  end

  describe '#raw_info' do
    let(:body) { '{"accounts": [{"id": 1}]}' }
    let(:response) { double("response", headers: headers, status: 200, body: body) }

    before do
      allow(subject).to receive(:access_token).and_return(double)
      expect(subject.access_token).to receive(:get).with("/api/v3/accounts")
        .and_return(OAuth2::Response.new(response))
    end

    context "when Content-Type not supported" do
      let(:headers) { { "Content-Type" => "application/foo-bar" } }

      it "blows up with NoMethodError" do
        expect { subject.raw_info }.to raise_error(NoMethodError)
      end
    end

    context "when Content-Type supported" do
      let(:headers) { { "Content-Type" => "application/vnd.api+json" } }

      it "fetches account info from api v3" do
        expect(subject.raw_info).to eq("id" => 1)
      end
    end

    context "when Content-Type supported" do
      let(:headers) { { "Content-Type" => "application/json" } }

      it "fetches account info from api v3" do
        expect(subject.raw_info).to eq("id" => 1)
      end
    end
  end
end

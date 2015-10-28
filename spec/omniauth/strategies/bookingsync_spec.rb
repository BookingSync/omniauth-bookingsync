require "spec_helper"
require "omniauth-bookingsync"

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
      expect(subject.authorize_params[:account_id]).to eq("123")
    end
  end

  describe '#raw_info' do
    it "fetches account info from api v3" do
      allow(subject).to receive(:access_token).and_return(double)
      response = double(parsed: { "accounts" => [{ "id" => 1 }] })
      expect(subject.access_token).to receive(:get).with("/api/v3/accounts")
        .and_return(response)
      expect(subject.raw_info).to eq("id" => 1)
    end
  end
end

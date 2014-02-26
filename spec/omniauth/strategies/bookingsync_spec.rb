require 'spec_helper'
require 'omniauth-bookingsync'

describe OmniAuth::Strategies::BookingSync do
  before do
    OmniAuth.config.test_mode = true
  end

  subject do
    OmniAuth::Strategies::BookingSync.new(nil, @options || {})
  end

  it_should_behave_like 'an oauth2 strategy'

  describe '#client' do
    it 'should have the correct site' do
      subject.client.site.should eq("https://www.bookingsync.com/")
    end

    it 'should have the correct authorization url' do
      subject.client.options[:authorize_url].should eq("/oauth/authorize")
    end

    it 'should have the correct token url' do
      subject.client.options[:token_url].should eq('/oauth/token')
    end
  end

  describe '#callback_path' do
    it 'should have the correct callback path' do
      subject.callback_path.should eq('/auth/bookingsync/callback')
    end
  end

  describe '#raw_info' do
    it 'should fetch account info from api v3' do
      subject.stub(:access_token => double)
      response = double(:parsed => {'accounts' => [{'id' => 1}]})
      subject.access_token.should_receive(:get).with('/api/v3/accounts').
        and_return(response)
      subject.raw_info.should eq({'id' => 1})
    end
  end
end

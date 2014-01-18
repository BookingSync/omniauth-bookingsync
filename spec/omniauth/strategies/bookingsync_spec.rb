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
      subject.client.site.should eq("http://www.bookingsync.com/")
    end

    it 'should have the correct authorization url' do
      subject.client.options[:authorize_url].should eq("https://www.bookingsync.com/oauth/authorize")
    end

    it 'should have the correct token url' do
      subject.client.options[:token_url].should eq('https://www.bookingsync.com/oauth/token')
    end
  end

  describe '#callback_path' do
    it 'should have the correct callback path' do
      subject.callback_path.should eq('/auth/bookingsync/callback')
    end
  end
end
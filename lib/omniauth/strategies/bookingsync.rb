require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class BookingSync < OmniAuth::Strategies::OAuth2
      option :name, 'bookingsync'

      option :client_options, {
        :site => 'http://www.bookingsync.com/'
      }
    end
  end
end

OmniAuth.config.add_camelization 'bookingsync', 'BookingSync'

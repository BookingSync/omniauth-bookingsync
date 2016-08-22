require "omniauth-oauth2"

module OmniAuth
  module Strategies
    class BookingSync < OmniAuth::Strategies::OAuth2
      option :name, "bookingsync"

      option :client_options, site: "https://www.bookingsync.com/"

      uid { raw_info["id"] }

      info do
        {
          business_name: raw_info["business_name"]
        }
      end

      def raw_info
        @raw_info ||= access_token.get("/api/v3/accounts").parsed["accounts"].first
      end

      def authorize_params
        super.tap do |params|
          if request.params["account_id"]
            params[:account_id] = request.params["account_id"]
          end
        end
      end
    end
  end
end

OAuth2::Response.register_parser(:json, ["application/vnd.api+json"]) do |body|
  MultiJson.load(body) rescue body # rubocop:disable RescueModifier
end

OmniAuth.config.add_camelization "bookingsync", "BookingSync"

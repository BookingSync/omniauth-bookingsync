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
          bookingsync_account_id = OmniAuth::BookingSync::Identifier.new(
            request.params["_bookingsync_account_id"])
          account_id = OmniAuth::BookingSync::Identifier.new(request.params["account_id"])

          if bookingsync_account_id.valid?
            params[:account_id] = bookingsync_account_id.value
          elsif account_id.valid?
            params[:account_id] = account_id.value
          end
        end
      end

      # Fixes regression in omniauth-oauth2 v1.4.0 by
      # https://github.com/intridea/omniauth-oauth2/commit/85fdbe117c2a4400d001a6368cc359d88f40abc7
      def callback_url
        options[:redirect_uri] || (full_host + script_name + callback_path)
      end
    end
  end
end

OAuth2::Response.register_parser(:json, ["application/vnd.api+json"]) do |body|
  MultiJson.load(body) rescue body # rubocop:disable RescueModifier
end

OmniAuth.config.add_camelization "bookingsync", "BookingSync"

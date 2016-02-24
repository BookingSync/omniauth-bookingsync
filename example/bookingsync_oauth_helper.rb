require "sinatra"
require "json"
require "omniauth-bookingsync"

use Rack::Session::Cookie

use OmniAuth::Builder do
  provider :bookingsync, ENV['BOOKINGSYNC_CLIENT_ID'], ENV['BOOKINGSYNC_CLIENT_SECRET'], {
    scope: ENV['BOOKINGSYNC_SCOPE']
  }
end

get "/" do
  <<-HTML
<html>
  <head>
    <style>
      body {
        text-align: center;
      }

      a {
        display: inline-block;
        padding: 10px 20px;
        font-size: 16px;
        color: #fff;
        background-color: #1B57AA;
        text-decoration: none;
        border-radius: 4px;
        margin: 100px auto 0;
      }

      a:hover {
        background-color: #2b88dc;
      }
    </style>
  </head>
  <body>
    <p><a href="/auth/bookingsync">Sign in with BookingSync</a></p>
  </body>
</html>
HTML
end

get "/auth/:provider/callback" do
  request.env["omniauth.auth"].to_hash.to_json
end

get "/auth/failure" do
  content_type "text/plain"
  params[:message]
end

require 'sinatra'
require 'omniauth-bookingsync'
require 'json'

puts "-" * 60
puts "BookingSync OAuth helper for API v3".center(60)
puts "-" * 60
puts ""
puts "Requirements:"
puts "  => Create a BookingSync Application from"
puts "  https://www.bookingsync.com/en/partners/applications"
puts ""
puts "  => Use http://localhost:4567/auth/bookingsync/callback as return URL"
puts ""
puts "Enter your Application ID"
set :application_id, gets.strip
puts ""
puts "Enter your Application Secret"
set :application_secret, gets.strip
puts ""
puts "-" * 60
puts "Visit http://localhost:4567".center(60)
puts "-" * 60
puts "Press CMD + C to stop"
puts ""

use Rack::Session::Cookie

use OmniAuth::Builder do
  provider :bookingsync, settings.application_id, settings.application_secret
end

get '/' do
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

get '/auth/:provider/callback' do
  content_type 'application/json'
  request.env['omniauth.auth'].to_hash.to_json
end

get '/auth/failure' do
  content_type 'text/plain'
  params[:message]
end

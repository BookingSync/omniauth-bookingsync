require 'rubygems'
require 'bundler'
Bundler.setup

require './bookingsync_oauth_helper'

run Sinatra::Application

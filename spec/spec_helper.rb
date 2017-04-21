require "bundler/setup"
require "rspec"
require "omniauth-bookingsync"

Dir[File.expand_path("../support/**/*", __FILE__)].each { |f| require f }

RSpec.configure do |_config|
end

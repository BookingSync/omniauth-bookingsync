# -*- encoding: utf-8 -*-
require File.expand_path("../lib/omniauth/bookingsync/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name = "omniauth-bookingsync"
  gem.version = OmniAuth::BookingSync::VERSION
  gem.platform = Gem::Platform::RUBY
  gem.authors = ["Sebastien Grosjean"]
  gem.email = ["dev@bookingsync.com"]
  gem.homepage = "https://github.com/BookingSync/omniauth-bookingsync"
  gem.summary = "An OmniAuth 1.0 strategy for BookingSync OAuth2 identification."
  gem.description = "An OmniAuth 1.0 strategy for BookingSync OAuth2 identification."

  gem.executables = `git ls-files -- exe/*`.split("\n").map { |f| File.basename(f) }
  gem.files = `git ls-files`.split("\n")
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ["lib"]

  gem.add_dependency "omniauth", "~> 1.6"
  gem.add_dependency "omniauth-oauth2", "<= 1.4"
  gem.add_dependency "oauth2", "~> 1.3.0"

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rubocop"
  gem.add_development_dependency "appraisal"
end

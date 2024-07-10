source 'https://rubygems.org'

gem 'activesupport'
gem 'base64'
gem 'discordrb'
gem 'opus-ruby'
gem 'sinatra'
gem 'rackup'
# FIXME: Rest Client is completely unmaintained, move away from it ASAP
gem 'rest-client'
# gem 'faraday'

# FIXME: Don't load dev dependencies in production Dockerfile
group :test do
  gem 'bundler-audit'
  gem 'byebug'
  gem 'rake'
  gem 'rspec'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rspec'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
end

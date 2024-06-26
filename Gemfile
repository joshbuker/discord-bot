source 'https://rubygems.org'

gem 'activesupport'
gem 'base64'
gem 'discordrb'
gem 'opus-ruby'
gem 'rest-client'

# FIXME: Don't load dev dependencies in production Dockerfile
group :test do
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'bundler-audit'
  gem 'byebug'
  gem 'rake'
  gem 'rspec'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rspec'
end

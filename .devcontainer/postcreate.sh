#!/bin/bash

bundle config set path vendor/bundle
bundle install --jobs=1
bundle exec ruby lib/discord_bot.rb

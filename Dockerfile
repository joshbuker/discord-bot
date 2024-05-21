FROM ruby:3.2.1

WORKDIR /usr/src/app

# Install system dependencies
RUN apt-get update
RUN apt-get install -y libsodium-dev libopus0 ffmpeg opus-tools libopus-dev

RUN gem install bundler

# If something changed in the lockfile, explode
RUN bundle config --global frozen 1

# Install Ruby dependencies
# COPY Gemfile Gemfile.lock ./
COPY Gemfile .
RUN bundle install

# Copy the application / source into the container
COPY ./data ./data
COPY ./lib ./lib
COPY LICENSE .

CMD ["bundle", "exec", "ruby", "lib/discord_bot.rb"]

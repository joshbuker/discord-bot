FROM ruby:3.2.1

WORKDIR /usr/src/app

# Install system dependencies
RUN apt-get update
RUN apt-get install -y libsodium-dev libopus0 ffmpeg opus-tools libopus-dev python3-pip python3-venv

# Install virtual env for Python, because it's dumb
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install yt-dlp for usage with voice channel commands
RUN pip install yt-dlp
RUN ln -s $(which yt-dlp) /usr/local/bin/youtube-dl

# Install bundler
RUN gem install bundler

# If something changed in the lockfile, explode
RUN bundle config --global frozen 1

# Install Ruby dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the application / source into the container
COPY ./bin ./bin
COPY ./data ./data
COPY ./lib ./lib
COPY LICENSE .

CMD ["bundle", "exec", "ruby", "bin/run_bot.rb"]

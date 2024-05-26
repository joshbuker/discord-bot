# Which Ruby version to use. You may need to use a more restrictive version,
# e.g. `3.0`
ARG VARIANT=3

# Pull Microsoft's ruby devcontainer base image
FROM mcr.microsoft.com/devcontainers/ruby:${VARIANT}

RUN apt-get update
RUN apt-get install -y libsodium-dev libopus0 ffmpeg opus-tools libopus-dev python3-pip python3-venv

# God, python is annoying sometimes
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install yt-dlp for usage with voice channel commands
RUN pip install yt-dlp
RUN ln -s $(which yt-dlp) /usr/local/bin/youtube-dl

# Ensure we're running the latest bundler, as what ships with the Ruby image may
# not be current, and bundler will auto-downgrade to match the Gemfile.lock
RUN gem install bundler

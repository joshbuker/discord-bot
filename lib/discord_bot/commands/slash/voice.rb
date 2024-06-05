module DiscordBot
  module Commands
    module Slash
      ##
      # Command for interacting with voice chat.
      #
      # rubocop:disable Metrics/ClassLength
      # rubocop:disable Metrics/MethodLength
      #
      class Voice < Base
        class << self
          def description
            'Connect and play audio over voice channel'
          end

          def register
            Bot.register_command(command_name, description) do |command|
              command.subcommand(:connect, 'Connect to a voice channel')
              command.subcommand(:disconnect, 'Disconnect from a voice channel')
              command.subcommand(:tuturu, 'Play tuturu in current voice channel')
              command.subcommand(:stop, 'Stop playing the current audio')
              command.subcommand(:youtube, 'Play audio from a YouTube video') do |options|
                options.string(:url, 'URL of the youtube video', required: true)
              end
            end
          end

          # FIXME: Is there a way to fix the branch complexity of this?
          # rubocop:disable Metrics/AbcSize
          def handle
            Bot.command_callback(command_name).subcommand(:connect) do |event|
              connect(DiscordBot::Events::Command.new(event))
            end

            Bot.command_callback(command_name).subcommand(:disconnect) do |event|
              disconnect(DiscordBot::Events::Command.new(event))
            end

            Bot.command_callback(command_name).subcommand(:stop) do |event|
              stop_playing(DiscordBot::Events::Command.new(event))
            end

            Bot.command_callback(command_name).subcommand(:tuturu) do |event|
              play_tuturu(DiscordBot::Events::Command.new(event))
            end

            Bot.command_callback(command_name).subcommand(:youtube) do |event|
              play_youtube(DiscordBot::Events::Command.new(event))
            end
          end
          # rubocop:enable Metrics/AbcSize

          private

          def connected_to_voice?(voice_channel)
            return false unless voice_channel.present?

            Bot.voice(voice_channel.id).present?
          end

          def connect(command)
            voice_channel = command.user_voice_channel
            if connected_to_voice?(voice_channel)
              command.respond_with("Already connected to #{voice_channel.name}")
            elsif voice_channel.nil?
              command.respond_with(
                "You're not in any voice channel!\nPlease join a voice " \
                'channel then run `/voice connect` again.'
              )
            else
              command.respond_with(
                "Attempting to join voice channel #{voice_channel.name}..."
              )
              Bot.voice_connect(voice_channel)
              Logger.info "Connected to voice channel: #{voice_channel.name}"
              command.update_response(
                "Joined voice channel #{voice_channel.name}"
              )
            end
          end

          def disconnect(command)
            voice_channel = command.bot_voice_channel
            if connected_to_voice?(voice_channel)
              voip = Bot.voice(voice_channel.id)
              Logger.info(
                "Disconnecting from voice channel: #{voice_channel.name}"
              )
              voip.destroy
              command.respond_with(
                "Disconnected from voice channel #{voice_channel.name}"
              )
            else
              command.respond_with(
                'Nothing to do, not connected to voice currently'
              )
            end
          end

          def stop_playing(command)
            voice_channel = command.bot_voice_channel
            if connected_to_voice?(voice_channel)
              voip = Bot.voice(voice_channel.id)
              Logger.info 'Stopping audio'
              command.respond_with('Stopping playback...')
              voip.stop_playing
              command.update_response('Playback stopped.')
            else
              command.respond_with(
                'Nothing to do, not connected to voice currently'
              )
            end
          end

          # Yo dawg, I heard you like vulnerabilities
          def youtube_video_io(url)
            sanitized_url = Shellwords.escape(url)
            IO.popen("youtube-dl -q -o - #{sanitized_url}")
          end

          def valid_youtube_url?(url)
            uri = URI(url)
            ['youtu.be', 'youtube.com', 'www.youtube.com'].include?(uri.host)
          rescue StandardError
            false
          end

          def play_tuturu(command)
            voice_channel = command.bot_voice_channel
            if connected_to_voice?(voice_channel)
              voip = Bot.voice(voice_channel.id)
              if tuturu_sound_file.present?
                Logger.info 'Playing tuturu.wav'
                command.respond_with('Playing sound...')
                voip.play_file(tuturu_sound_file)
                command.update_response('Tuturu!')
              else
                Logger.warn 'Could not find tuturu.wav'
              end
            else
              command.respond_with(
                'Please connect to voice with `/voice connect` first'
              )
            end
          end

          def play_youtube(command)
            voice_channel = command.bot_voice_channel
            url = command.options['url']
            if connected_to_voice?(voice_channel)
              voip = Bot.voice(voice_channel.id)
              if valid_youtube_url?(url)
                Logger.info "Playing YouTube video: #{url}"
                command.respond_with('Playing YouTube video...')
                voip.play_io(youtube_video_io(url))
                command.update_response('Finished playing')
              else
                Logger.warn 'Invalid YouTube URL'
                command.respond_with('Invalid YouTube URL')
              end
            else
              command.respond_with(
                'Please connect to voice with `/voice connect` first'
              )
            end
          end

          def tuturu_sound_file
            if File.exist?('/workspaces/discord-bot/data/tuturu.wav')
              '/workspaces/discord-bot/data/tuturu.wav'
            elsif File.exist?('/usr/src/app/data/tuturu.wav')
              '/usr/src/app/data/tuturu.wav'
            end
          end
        end
      end
      # rubocop:enable Metrics/ClassLength
      # rubocop:enable Metrics/MethodLength
    end
  end
end

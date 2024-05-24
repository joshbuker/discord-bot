module DiscordBot
  module Commands
    class Tuturu < Base
      class << self
        def description
          'Play a fun sound in your current voice channel'
        end

        def run(command_run)
          command_run.respond_with('Attempting to join channel...')
          channel = connect_to_channel(command_run)

          voip = @bot.voice(channel.id)
          if voip
            begin
              if tuturu_sound_file
                Logger.log 'Playing tuturu.wav'
                voip.play_file(tuturu_sound_file) unless tuturu_sound_file.nil?
              else
                Logger.log 'Could not find tuturu.wav'
              end
            rescue StandardError => error
              Logger.log("Failed to play sound due to: \"#{error.message}\"")
            ensure
              Logger.log "Disconnecting from voice channel: #{channel.name}"
              voip.destroy
            end
            command_run.update_response('Tuturu!')
          end
        end

        private

        def tuturu_sound_file
          if File.exist?('/workspaces/discord-bot/data/tuturu.wav')
            '/workspaces/discord-bot/data/tuturu.wav'
          elsif File.exist?('/usr/src/app/data/tuturu.wav')
            '/usr/src/app/data/tuturu.wav'
          else
            nil
          end
        end

        def connect_to_channel(command_run)
          channel = command_run.user.voice_channel

          unless channel
            command_run.update_response("You're not in any voice channel!\nPlease join a voice channel then run `/tuturu` again.")
            return
          end

          @bot.voice_connect(channel)
          Logger.log "Connected to voice channel: #{channel.name}"
          command_run.update_response('Channel joined, playing sound momentarily...')
          return channel
        end
      end
    end
  end
end

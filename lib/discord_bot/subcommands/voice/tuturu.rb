module DiscordBot
  module Subcommands
    module Voice
      class Tuturu < DiscordBot::Subcommand
        def description
          'Play tuturu in current voice channel'
        end

        def run(command_event)
          voice_channel = command.bot_voice_channel
          if connected_to_voice?(voice_channel)
            voip = Bot.voice(voice_channel.id)
            if tuturu_sound_file.present?
              logger.info 'Playing tuturu.wav'
              command.respond_with('Playing sound...')
              voip.play_file(tuturu_sound_file)
              command.update_response('Tuturu!')
            else
              logger.warn 'Could not find tuturu.wav'
            end
          else
            command.respond_with(
              'Please connect to voice with `/voice connect` first'
            )
          end
        end

        private

        def tuturu_sound_file
          if File.exist?('/workspaces/discord-bot/data/tuturu.wav')
            '/workspaces/discord-bot/data/tuturu.wav'
          elsif File.exist?('/usr/src/app/data/tuturu.wav')
            '/usr/src/app/data/tuturu.wav'
          end
        end
      end
    end
  end
end

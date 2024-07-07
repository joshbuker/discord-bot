module DiscordBot
  module Subcommands
    module Voice
      class Tuturu < DiscordBot::Subcommand
        def description
          'Play tuturu in current voice channel'
        end

        def run(command_event)
          voice_channel = command_event.bot_voice_channel
          if connected_to_voice?(voice_channel)
            voip = bot.discord_bot.voice(voice_channel.id)
            if tuturu_sound_file.present?
              logger.info 'Playing tuturu.wav'
              command_event.respond_with('Playing sound...')
              voip.play_file(tuturu_sound_file)
              command_event.update_response('Tuturu!')
            else
              logger.warn 'Could not find tuturu.wav'
            end
          else
            command_event.respond_with(
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

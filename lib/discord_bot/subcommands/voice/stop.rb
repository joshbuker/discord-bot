module DiscordBot
  module Subcommands
    module Voice
      class Stop < DiscordBot::Subcommand
        def description
          'Stop playing the current audio'
        end

        def run(command_event)
          voice_channel = command.bot_voice_channel
          if connected_to_voice?(voice_channel)
            voip = Bot.voice(voice_channel.id)
            logger.info 'Stopping audio'
            command.respond_with('Stopping playback...')
            voip.stop_playing
            command.update_response('Playback stopped.')
          else
            command.respond_with(
              'Nothing to do, not connected to voice currently'
            )
          end
        end
      end
    end
  end
end

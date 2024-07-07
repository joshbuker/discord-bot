module DiscordBot
  module Subcommands
    module Voice
      class Stop < DiscordBot::Subcommand
        def description
          'Stop playing the current audio'
        end

        def run(command_event)
          voice_channel = command_event.bot_voice_channel
          if connected_to_voice?(voice_channel)
            voip = bot.discord_bot.voice(voice_channel.id)
            logger.info 'Stopping audio'
            command_event.respond_with('Stopping playback...')
            voip.stop_playing
            command_event.update_response('Playback stopped.')
          else
            command_event.respond_with(
              'Nothing to do, not connected to voice currently'
            )
          end
        end
      end
    end
  end
end

module DiscordBot
  module Subcommands
    module Voice
      class Disconnect < DiscordBot::Subcommand
        def description
          'Disconnect from a voice channel'
        end

        def run(command_event)
          voice_channel = command_event.bot_voice_channel
          if connected_to_voice?(voice_channel)
            voip = bot.discord_bot.voice(voice_channel.id)
            logger.info(
              "Disconnecting from voice channel: #{voice_channel.name}"
            )
            voip.destroy
            command_event.respond_with(
              "Disconnected from voice channel #{voice_channel.name}"
            )
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

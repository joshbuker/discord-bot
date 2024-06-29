module DiscordBot
  module Subcommands
    module Voice
      class Connect < DiscordBot::Subcommand
        def description
          'Connect to a voice channel'
        end

        def run(command_event)
          voice_channel = command_event.user_voice_channel
          if connected_to_voice?(voice_channel)
            command_event.respond_with(
              "Already connected to #{voice_channel.name}"
            )
          elsif voice_channel.nil?
            command_event.respond_with(
              "You're not in any voice channel!\nPlease join a voice " \
              'channel then run `/voice connect` again.'
            )
          else
            command_event.respond_with(
              "Attempting to join voice channel #{voice_channel.name}..."
            )
            bot.discord_bot.voice_connect(voice_channel)
            logger.info "Connected to voice channel: #{voice_channel.name}"
            command_event.update_response(
              "Joined voice channel #{voice_channel.name}"
            )
          end
        end
      end
    end
  end
end

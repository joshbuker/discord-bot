module DiscordBot
  module Commands
    module Message
      ##
      # Message command for replying to a specific message, even if the bot was
      # not mentioned.
      #
      class ReplyToMessage < Base
        class << self
          def command_name
            'Reply to this message'
          end

          # rubocop:disable Metrics/MethodLength
          def run(command)
            message = command.target_message
            channel_id = message.channel_id
            Logger.info(
              "#{command.whois} requested a reply to the following message:" \
              "\n#{message.content}"
            )
            command.respond_with('Replying to message...')
            typing_thread = message.start_typing_thread
            response = Bot.generate_llm_response(
              channel_id: channel_id,
              message:    message
            )
            typing_thread.exit
            command.update_response('Reply sent')
            message.reply_with(response.message)
          end
          # rubocop:enable Metrics/MethodLength
        end
      end
    end
  end
end

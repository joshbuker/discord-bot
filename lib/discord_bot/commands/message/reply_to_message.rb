module DiscordBot
  module Commands
    module Message
      ##
      # Message command for replying to a specific message, even if the bot was
      # not mentioned.
      #
      class ReplyToMessage < Base
        def command_name
          'Reply to this message'
        end

        def run(command_event)
          message = command_event.target_message
          logger.info(
            "#{command_event.whois} requested a reply to the following " \
            "message:\n#{message.content}"
          )
          command_event.respond_with('Replying to message...')
          response =
            bot.conversation(message.channel_id).generate_response(message)
          message.reply_with(response.message)
          command_event.update_response('Reply sent')
        end
      end
    end
  end
end

module DiscordBot
  module Commands
    class ReplyToMessage < MessageCommand
      class << self
        def command_name
          'Reply to this message'
        end

        def run(command)
          message = command.target_message
          channel_id = message.channel_id
          Logger.info "#{command.whois} requested a reply to the following message:\n#{message.content}"
          command.respond_with('Replying to message...')
          typing_thread = message.start_typing_thread
          response = Bot.generate_llm_response(channel_id: channel_id, message: message)
          typing_thread.exit
          command.update_response('Reply sent')
          message.reply_with(response.message)
        end
      end
    end
  end
end

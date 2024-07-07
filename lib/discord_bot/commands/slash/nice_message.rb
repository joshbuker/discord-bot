module DiscordBot
  module Commands
    module Slash
      ##
      # Allows a user to command the bot to send another user a message
      #
      # Written by @kmatthews123
      #
      class NiceMessage < Base
        def description
          'Allows user to send a nice message to another user though ' \
          "#{bot.config.bot_name}"
        end

        def register_options(options)
          options.user(:user, 'What user to message?', required: true)
          options.string(:message, 'what message to send', required: true)
        end

        # FIXME: Update this to inject a message into chat history from the
        #        calling user, rather than the target user
        def run(command_event)
          require_admin!(command_event) { return }

          target_user = DiscordBot::User.new(
            bot.discord_bot.user(command_event.options['user'])
          )
          message = command_event.options['message']
          conversation = DiscordBot::Conversation.new(bot)
          command_event.respond_with('Sending your nice message...')
          response = conversation.generate_response(message)
          target_user.direct_message(response.message)
          command_event.update_response('Nice message sent')
          logger.info(
            "Prompt: #{command_event.options['message']}\n" \
            "Message sent: #{response.message}\n" \
            "Sender: #{command_event.whois}\n" \
            "Sent to: #{target_user.whois}"
          )
        end
      end
    end
  end
end

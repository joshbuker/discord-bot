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

        # rubocop:disable Metrics
        # FIXME: Update this to inject a message into chat history from the
        #        calling user, rather than the target user
        def run(command_event)
          require_admin!(command_event){ return }

          message = command.options['message']
          conversation = DiscordBot::LLM::Conversation.new
          model = DiscordBot::LLM::Model.new
          command.respond_with('Sending your nice message...')
          response = DiscordBot::LLM::Response.new(
            conversation_history: conversation,
            user_message:         message,
            model:                model
          )
          command_event.target_user.direct_message(response.message)
          command.update_response('Nice message sent')
          logger.info(
            "Message sent: #{command.options['message']}\n" \
            "Sender: #{command.whois}\n"\
            "Sent to: #{user.whois}"
          )
        end
        # rubocop:enable Metrics
      end
    end
  end
end

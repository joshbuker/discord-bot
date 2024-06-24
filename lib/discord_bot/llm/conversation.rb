module DiscordBot
  module LLM
    ##
    # Represents a conversation history with the LLM.
    #
    class Conversation
      attr_reader :current_system_prompt

      def initialize(system_prompt: nil)
        @conversation =
          if system_prompt.nil?
            [default_system_prompt]
          else
            [{
              role:    'system',
              content: system_prompt
            }]
          end

        @current_system_prompt =
          system_prompt || default_system_prompt[:content]
      end

      def append(message:, role: 'user')
        raise InvalidArgument unless %w[user assistant system].include?(role)

        @conversation.push({
          role:    role,
          content: message
        })
      end

      def messages
        @conversation
      end

      # TODO: Allow setting new system prompt without reseting chat history
      def set_system_prompt(system_prompt:)
        @conversation = [{
          role:    'system',
          content: system_prompt
        }]
        @current_system_prompt = system_prompt
        system_prompt
      end

      # TODO: Allow reseting system prompt without reseting chat history
      def reset_system_prompt
        @conversation = [default_system_prompt]
        @current_system_prompt = default_system_prompt[:content]
        default_system_prompt[:content]
      end

      private

      def default_system_prompt
        {
          role:    'system',
          content: 'You are a chat bot with the name ' \
            "\"#{DiscordBot::Config.bot_name}\". Your Discord ID is " \
            "<@1241557600940855397>, try not to confuse your ID with other's " \
            'when someone asks you to ping someone else. You are based after ' \
            'the character Ruby Rose from RWBY, but try not to roleplay or ' \
            'get caught up in that backstory.'
        }
      end
    end
  end
end

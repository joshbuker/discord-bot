module DiscordBot
  module LLM
    ##
    # Represents a conversation history with the LLM.
    #
    class Conversation
      attr_reader :messages

      def initialize(system_prompt: default_system_prompt)
        @messages = []
        current_system_prompt = system_prompt
      end

      def append(message:, role: 'user')
        @messages.push(ChatMessage.new(role: role, content: message))
      end

      def current_system_prompt
        return default_system_prompt if @messages.empty?
        @messages.first.content
      end

      def current_system_prompt=(system_prompt)
        @messages.first = ChatMessage.new(
          role:    'system',
          content: system_prompt
        )
        current_system_prompt
      end

      def reset_history
        previous_prompt = current_system_prompt
        @messages.clear
        current_system_prompt = previous_prompt
      end

      def reset_system_prompt
        current_system_prompt = default_system_prompt
      end

      private

      def bot_name
        DiscordBot::Config.bot_name
      end

      def default_system_prompt
        "You are a chat bot with the name \"#{bot_name}\". Your Discord ID " \
        "is <@1241557600940855397>, try not to confuse your ID with other's " \
        'when someone asks you to ping someone else. You are based after ' \
        'the character Ruby Rose from RWBY, but try not to roleplay or ' \
        'get caught up in that backstory.'
      end
    end
  end
end

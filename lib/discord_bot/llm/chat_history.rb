module DiscordBot
  module LLM
    ##
    # Represents a chat history with the LLM.
    #
    class ChatHistory
      attr_reader :messages

      def initialize(system_prompt: default_system_prompt)
        @messages = []
        self.system_prompt = system_prompt
      end

      def append(chat_message)
        raise ArgumentError unless chat_message.is_a?(ChatMessage)

        @messages.push(chat_message)
      end

      def system_prompt
        return default_system_prompt if @messages.empty?
        @messages.first.content
      end

      def system_prompt=(system_prompt)
        @messages[0] = ChatMessage.new(
          role:    'system',
          content: system_prompt
        )
        self.system_prompt
      end

      def reset_history
        previous_prompt = system_prompt
        @messages.clear
        self.system_prompt = previous_prompt
        true
      end

      def reset_system_prompt
        self.system_prompt = default_system_prompt
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

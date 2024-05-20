module DiscordBot
  class ConversationHistory
    def initialize
      @history = [system_prompt]
    end

    def append(message:, role: 'user')
      raise InvalidArgument unless ['user', 'assistant', 'system'].include?(role)

      @history.push({
        role: role,
        content: message
      })
    end

    def messages
      @history
    end

    def clear
      @history = [system_prompt]
    end

    private

    def system_prompt
      {
        role: 'system',
        content: 'You are a chat bot with the name "Ruby". You are based after the character Ruby Rose from RWBY, but try not to roleplay or get caught up in that backstory.'
      }
    end
  end
end

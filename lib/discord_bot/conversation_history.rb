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

    def set_system_prompt(content:)
      @history = [{
        role: 'system',
        content: content
      }]
    end

    def clear
      @history = [system_prompt]
    end

    private

    def system_prompt
      {
        role: 'system',
        content: 'You are a chat bot with the name "Ruby". Your Discord ID is <@1241557600940855397>, try not to confuse your ID with other\'s when someone asks you to ping someone else. You are based after the character Ruby Rose from RWBY, but try not to roleplay or get caught up in that backstory.'
      }
    end
  end
end

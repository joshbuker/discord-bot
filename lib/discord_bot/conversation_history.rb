module DiscordBot
  class ConversationHistory
    def initialize
      @history = []
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
      @history = []
    end
  end
end

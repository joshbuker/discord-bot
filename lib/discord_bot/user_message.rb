module DiscordBot
  class UserMessage
    def initialize(event)
      @event = event
    end

    def message
      @event.message
    end

    def reply_with(response)
      @event.message.reply!(response)
    end
  end
end

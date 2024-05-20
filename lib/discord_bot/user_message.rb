module DiscordBot
  class UserMessage
    def initialize(event)
      @event = event
    end

    def channel
      @event.channel
    end

    def server
      @event.server
    end

    def message
      @event.message
    end

    def reply_with(response)
      @event.message.reply!(response)
    end
  end
end

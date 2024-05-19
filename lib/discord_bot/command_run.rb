module DiscordBot
  class CommandRun
    def initialize(event)
      @event = event
    end

    def user
      @event.user
    end

    def respond_with(response)
      @event.respond(content: response)
    end

    def update_response(response)
      @event.edit_response(content: response)
    end
  end
end

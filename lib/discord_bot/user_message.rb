module DiscordBot
  class UserMessage
    def initialize(event)
      @event = event
    end

    def event
      @event
    end

    def channel
      @event.channel
    end

    def server
      @event.server
    end

    def user
      @event.user
    end

    def display_name
      user.nickname.nil? ? user.global_name : user.nickname
    end

    def message
      @event.message
    end

    def reply_with(response)
      return if response.size.zero?

      if response.size <= 2000
        @event.message.reply!(response)
      else
        responses = chop(response, 2000)
        respond_to = @event.message
        responses.each do |chopped_response|
          next if chopped_response.nil?
          respond_to = respond_to.reply!(chopped_response)
        end
      end
    end

    private

    def chop(string, size)
      count = (string.size-1 / size)
      (0..count).map do |i|
        string[i*size, size]
      end
    end
  end
end

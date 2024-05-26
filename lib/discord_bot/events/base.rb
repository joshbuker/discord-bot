module DiscordBot
  module Events
    class Base
      attr_reader :event

      def initialize(event)
        @event = event
      end

      def channel_id
        @event.channel.id
      end
    end
  end
end

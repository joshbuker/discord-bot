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

      def channel_name
        @event.channel.name
      end

      def user_id
        @event.user.id
      end

      def server_id
        @event.server.id
      end
    end
  end
end

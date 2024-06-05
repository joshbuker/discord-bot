module DiscordBot
  module Events
    ##
    # Represents a message received from Discord.
    #
    class Message < Base
      # Discord times out the typing indicator after ~5 seconds, so resend every
      # 3 seconds
      TYPING_SLEEP_INTERVAL = 3

      def channel
        @event.channel
      end

      def server
        @event.server
      end

      def from
        if server.present?
          "#{server.name} ##{channel.name}"
        else
          "<@#{user.id}> @#{channel.name} \"#{name}\""
        end
      end

      def name
        if @event.user.nickname.present?
          @event.user.nickname
        elsif @event.user.global_name.present?
          @event.user.global_name
        else
          @event.user.name
        end
      end

      def mention
        @event.user.mention
      end

      def user
        @event.user
      end

      def content
        @event.message.content
      end

      def message
        @event.message
      end

      def mentions_bot?
        @event.message.mentions.include?(Bot.user)
      end

      def direct_message?
        @event.server.nil?
      end

      def addressed_to_bot?
        mentions_bot? || direct_message?
      end

      # rubocop:disable Metrics/MethodLength
      def reply_with(response)
        return if response.empty?

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
      # rubocop:enable Metrics/MethodLength

      def start_typing_thread
        Thread.new do
          loop do
            channel.start_typing
            sleep(TYPING_SLEEP_INTERVAL)
          end
        end
      end

      private

      def chop(string, size)
        count = ((string.size - 1) / size)
        (0..count).map do |i|
          string[i * size, size]
        end
      end
    end
  end
end

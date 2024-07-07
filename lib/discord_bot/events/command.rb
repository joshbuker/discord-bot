module DiscordBot
  module Events
    ##
    # Represents a command received from Discord.
    #
    class Command < Base
      def user
        @event.user
      end

      def whois
        "@#{user.name}"
      end

      def options
        @event.options
      end

      def bot_voice_channel
        Bot.voice(server_id)&.channel
      end

      def user_voice_channel
        @event.user.voice_channel
      end

      def target_message
        DiscordBot::Events::Message.new(@event.target)
      end

      def target_user
        DiscordBot::User.new(user: @event.target)
      end

      def direct_message?
        @event.server_id.nil?
      end

      def ran_by_admin?
        Config.admin_users.include?(user)
      end

      def respond_with(response, only_to_user: true)
        @event.respond(content: response, ephemeral: only_to_user)
      end

      def update_response(response)
        @event.edit_response(content: response)
      end

      def send_file(file:, caption:, filename:, spoiler: false)
        @event.channel.send_file(
          file,
          caption:  caption,
          filename: filename,
          spoiler:  spoiler
        )
      end
    end
  end
end

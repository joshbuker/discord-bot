module DiscordBot
  class Config
    class << self
      def instance
        @instance ||= new(DEFAULTS)
      end

      def admin_users
        [
          DiscordBot::User.new(id: 121475289397198848)
        ]
      end

      def bot_name
        ENV['BOT_NAME'] || "Ruby"
      end

      # TODO: Determine least privilege and request that instead
      def discord_bot_intents
        :all
        # [:server_messages]
      end

      def discord_bot_token
        ENV['RUBY_DISCORD_BOT_TOKEN']
      end

      def slash_command_server_ids
        [
          933463011551764550,
          1237136024573051053
        ]
      end
    end
  end
end

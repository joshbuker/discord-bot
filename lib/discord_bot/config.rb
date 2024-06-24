module DiscordBot
  ##
  # Provides a globally accessible configuration for the Bot.
  #
  class Config
    LOG_LEVELS = {
      debug: 0,
      info: 1,
      warn: 2,
      error: 3,
      fatal: 4
    }
    DEFAULT_LOG_LEVEL = :info

    class << self
      # TODO: Migrate to Slash command permissions?
      def admin_users
        [
          DiscordBot::User.new(id: 121_475_289_397_198_848),
          DiscordBot::User.new(id: 227_141_869_962_919_936),
          DiscordBot::User.new(id: 381_899_834_564_804_622),
          DiscordBot::User.new(id: 478_093_835_172_446_209),
          DiscordBot::User.new(id: 722_652_181_894_791_238)
        ]
      end

      def bot_name
        ENV.fetch('BOT_NAME', 'Ruby')
      end

      # TODO: Determine least privilege and request that instead
      def discord_bot_intents
        :all
        # [:server_messages]
      end

      def discord_bot_token
        ENV.fetch('RUBY_DISCORD_BOT_TOKEN', nil)
      end

      def slash_command_server_ids
        [
          933_463_011_551_764_550,
          1_237_136_024_573_051_053
        ]
      end

      # Some way to log this on bootup? Probably should make Config an instance
      def log_level
        level = ENV['LOG_LEVEL']&.downcase&.to_sym || DEFAULT_LOG_LEVEL
        return level if LOG_LEVELS.key?(level)
        raise DiscordBot::Errors::InvalidConfig,
          "Invalid log level provided: #{level}"
      end

      def log_level?(level)
        LOG_LEVELS[log_level] <= LOG_LEVELS[level]
      end
    end
  end
end

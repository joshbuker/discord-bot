module DiscordBot
  ##
  # Provides a globally accessible configuration for the Bot.
  #
  class Config
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
        ENV['BOT_NAME'] || 'Ruby'
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
    end
  end
end

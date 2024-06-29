module DiscordBot
  module Initializers
    class MessageOfTheDay < DiscordBot::Initializer
      def run?
        !bot.config.skip_motd
      end

      def setup
        logger.info "Bot Invite URL: #{bot.discord_bot.invite_url}"
      end
    end
  end
end

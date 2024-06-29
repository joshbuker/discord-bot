module DiscordBot
  module Initializers
    class InitializeCallbacks < DiscordBot::Initializer
      def setup
        logger.info 'Initializing callbacks'
        DiscordBot::MessageHandler.new(bot).handle
        bot.commands.each(&:handle)
      end
    end
  end
end

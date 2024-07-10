module DiscordBot
  module Initializers
    class InitializeCallbacks < DiscordBot::Initializer
      def setup
        logger.info 'Initializing callbacks'
        DiscordBot::MessageHandler.new(bot).handle
        bot.commands.each(&:handle)
        bot.server_thread = Thread.new do
          DiscordBot::Server.set :bot, bot
          DiscordBot::Server.set :logger, DiscordBot::Error
          # FIXME: Try as hard as I can, the excess logging REFUSES TO GO AWAY!!
          #        I hate this with such a fiery passion, what the actual hell.
          DiscordBot::Server.disable :logging
          DiscordBot::Server.run!
        end

        # HACK: For some reason, Sinatra REALLY wants to eat the interrupt
        #       unless I trap it like this. Otherwise, it makes it unresponsive
        #       to ctrl+c after the first call (shutting down sinatra)...
        Signal.trap('INT') do
          bot.shutdown
        end
      end
    end
  end
end

module DiscordBot
  module Commands
    module Slash
      ##
      # Command for shutting down the bot.
      #
      class Exit < Base
        def description
          'Shutdown the bot'
        end

        def run(command_event)
          require_admin!(command_event){ return }

          command_event.respond_with 'Shutting down, see you next time!'
          logger.warn(
            "Shutting down per request by #{command_event.user.name}"
          )
          bot.shutdown
        end
      end
    end
  end
end

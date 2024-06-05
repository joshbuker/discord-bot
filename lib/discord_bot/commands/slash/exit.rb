module DiscordBot
  module Commands
    module Slash
      ##
      # Command for shutting down the bot.
      #
      class Exit < Base
        class << self
          def description
            'Shutdown the bot'
          end

          def run(command)
            return unless command.ran_by_admin?

            command.respond_with 'Shutting down, see you next time!'
            Logger.info "Shutting down per request by #{command.user.name}"
            Bot.shutdown
          end
        end
      end
    end
  end
end

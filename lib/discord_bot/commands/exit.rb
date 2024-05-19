module DiscordBot
  module Commands
    class Exit < Base
      AUTHORIZED_USERS = [
        121475289397198848
      ]

      def name
        :exit
      end

      def description
        'Shutdown the bot'
      end

      def run(command_run)
        return unless AUTHORIZED_USERS.include?(command_run.user.id)

        command_run.respond_with('Shutting down, see you next time!')
        Logger.log("Shutting down per request by #{command_run.user.name}")
        @bot.shutdown
      end
    end
  end
end

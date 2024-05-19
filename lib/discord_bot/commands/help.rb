module DiscordBot
  module Commands
    class Help < Base
      def name
        :help
      end

      def description
        'Provides a full list of commands in chat'
      end

      def run(command_run)
        command_run.respond_with(help_message)
      end

      private

      def help_message
        <<~help
          ```
          /help or /h - Show this help message
          /tuturu     - Play a fun sound in your current voice channel
          /source     - Get the source code for this bot
          ```
        help
      end
    end
  end
end

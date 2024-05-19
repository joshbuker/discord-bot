module DiscordBot
  module Commands
    class Source < Base
      def name
        :source
      end

      def description
        'Provides the source code for Ruby'
      end

      def run(command_run)
        command_run.respond_with("You can find my source code at: https://github.com/joshbuker/discord-bot")
      end
    end
  end
end

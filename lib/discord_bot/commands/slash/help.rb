module DiscordBot
  module Commands
    module Slash
      ##
      # Command for printing a list of commands. Probably redundant and can be
      # removed, considering how Discord shows slash commands.
      #
      class Help < Base
        def description
          'Provides a full list of commands in chat'
        end

        def run(command_event)
          command_event.respond_with(help_message)
        end

        private

        def help_message
          <<~HELP
            ```
            /help or /h - Show this help message
            /tuturu     - Play a fun sound in your current voice channel
            /source     - Get the source code for this bot
            ```
          HELP
        end
      end
    end
  end
end

module DiscordBot
  module Commands
    module Slash
      ##
      # Command for finding the source code of the bot.
      #
      class Source < Base
        def description
          "Provides the source code for #{bot.config.bot_name}"
        end

        def run(command_event)
          command_event.respond_with(source_code_message)
        end

        private

        def source_code_message
          'You can find my source code at: ' \
          'https://github.com/joshbuker/discord-bot'
        end
      end
    end
  end
end

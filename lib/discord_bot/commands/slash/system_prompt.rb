module DiscordBot
  module Commands
    module Slash
      ##
      # Provides commands for interacting with the system prompt for the LLM.
      #
      class SystemPrompt < Base
        def description
          'Adjust the LLM System Prompt'
        end

        def subcommands
          [
            DiscordBot::Subcommands::SystemPrompt::Current.new(self),
            DiscordBot::Subcommands::SystemPrompt::Reset.new(self),
            DiscordBot::Subcommands::SystemPrompt::Set.new(self)
          ]
        end
      end
    end
  end
end

module DiscordBot
  module Commands
    module Slash
      ##
      # Provides methods for interacting with the LLM model.
      #
      class Model < Base
        def description
          'Make changes to the LLM Model'
        end

        def subcommands
          [
            DiscordBot::Subcommands::Model::Current.new(self),
            DiscordBot::Subcommands::Model::List.new(self),
            DiscordBot::Subcommands::Model::Pull.new(self),
            DiscordBot::Subcommands::Model::Reset.new(self),
            DiscordBot::Subcommands::Model::Set.new(self)
          ]
        end
      end
    end
  end
end

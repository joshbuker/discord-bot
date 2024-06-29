module DiscordBot
  module Commands
    module Slash
      ##
      # Command for interacting with voice chat.
      #
      class Voice < Base
        def description
          'Connect and play audio over voice channel'
        end

        def subcommands
          [
            DiscordBot::Subcommands::Voice::Connect.new(self),
            DiscordBot::Subcommands::Voice::Disconnect.new(self),
            DiscordBot::Subcommands::Voice::Generate.new(self),
            DiscordBot::Subcommands::Voice::Speak.new(self),
            DiscordBot::Subcommands::Voice::Stop.new(self),
            DiscordBot::Subcommands::Voice::Tuturu.new(self),
            DiscordBot::Subcommands::Voice::Youtube.new(self)
          ]
        end
      end
    end
  end
end

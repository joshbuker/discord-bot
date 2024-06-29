module DiscordBot
  module Commands
    module Slash
      ##
      # Command for generating images via Stable Diffusion.
      #
      class Image < Base
        def description
          'Uses stable diffusion to interact with images'
        end

        def servers
          bot.config.slash_command_server_ids
        end

        def subcommands
          [
            DiscordBot::Subcommands::Image::Generate.new(self)
          ]
        end
      end
    end
  end
end

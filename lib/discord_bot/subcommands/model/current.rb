module DiscordBot
  module Subcommands
    module Model
      class Current < DiscordBot::Subcommand
        def description
          'Show the currently loaded model'
        end

        def run(command_event)
          logger.info "#{command_event.whois} inspected the current model"
          model = bot.conversation(command_event.channel_id).model
          command_event.respond_with(
            "The currently loaded model for ##{command_event.channel_name} " \
            "is:\n#{model.about}"
          )
        end
      end
    end
  end
end

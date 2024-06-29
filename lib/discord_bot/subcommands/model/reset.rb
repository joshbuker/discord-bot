module DiscordBot
  module Subcommands
    module Model
      class Reset < DiscordBot::Subcommand
        def description
          'Reset to the default model'
        end

        def run(command_event)
          logger.info(
            "#{command_event.whois} has reset the LLM model to default for " \
            "#{command_event.channel_name}"
          )
          default_model = bot.conversation(command_event.channel_id).reset_model
          command_event.respond_with(
            "Reset the LLM model to default:\n#{default_model.about}",
            only_to_user: false
          )
        end
      end
    end
  end
end

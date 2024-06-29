module DiscordBot
  module Subcommands
    module SystemPrompt
      class Current < DiscordBot::Subcommand
        def description
          'Show the currently loaded system prompt'
        end

        def run(command_event)
          logger.info "#{command.whois} inspected the current system prompt"
          prompt = bot.conversation(command_event.channel_id).system_prompt
          command.respond_with(
            "The currently loaded system prompt for " \
            "##{command.channel_name} is:\n#{prompt}"
          )
        end
      end
    end
  end
end

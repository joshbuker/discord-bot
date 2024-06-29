module DiscordBot
  module Subcommands
    module Model
      class List < DiscordBot::Subcommand
        def description
          'List the available models'
        end

        def run(command_event)
          logger.info(
            "#{command_event.whois} requested a list of the available models"
          )
          models = DiscordBot::LLM::Model.available_models
          # TODO: Also show file size, parameter size, and quantization level
          formatted_list = models.map do |model|
            "- #{model.about}"
          end.join("\n")
          command_event.respond_with(
            "The currently available models are:\n#{formatted_list}\n\n" \
            'More can be found at: https://ollama.com/library'
          )
        end
      end
    end
  end
end

module DiscordBot
  module Subcommands
    module Model
      class Pull < DiscordBot::Subcommand
        def description
          'Fetch a new model for future use'
        end

        def register_options(options)
          options.string(:model, 'What model to fetch', required: true)
        end

        # TODO: Progress tracking via data streaming
        def run(command_event)
          require_admin!(
            command_event,
            'Due to the large size of models, this command is restricted ' \
            'to admins'
          ) { return }

          requested_model = command_event.options['model']
          logger.info(
            "#{command_event.whois} has requested the LLM model #{requested_model}"
          )
          command_event.respond_with("Pulling LLM model \"#{requested_model}\"...")
          model = DiscordBot::GenAI::Text::Model.new(
            model_name: requested_model,
            bot: bot
          )
          if model.available?
            command_event.update_response(
              "\"#{requested_model}\" is already available"
            )
          else
            begin
              model.pull
              command_event.update_response(
                "Pulled LLM model \"#{requested_model}\""
              )
            rescue DiscordBot::Errors::FailedToPullModel
              command_event.update_response(
                "Failed to pull LLM model \"#{requested_model}\""
              )
            end
          end
        end
      end
    end
  end
end

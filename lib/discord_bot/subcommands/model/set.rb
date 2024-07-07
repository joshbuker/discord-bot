module DiscordBot
  module Subcommands
    module Model
      class Set < DiscordBot::Subcommand
        def description
          'Set the current model'
        end

        def register_options(options)
          options.string(:model, 'What model to use', required: true)
        end

        def run(command_event)
          requested_model = command_event.options['model']
          model = DiscordBot::GenAI::Text::Model.new(
            model_name: requested_model,
            bot:        bot
          )
          if model.available?
            logger.info(
              "#{command_event.whois} has set the LLM model to " \
              "#{requested_model} for ##{command_event.channel_name}"
            )
            bot.conversation(command_event.channel_id).model = model
            command_event.respond_with(
              "Set LLM model to:\n\"#{model.about}\"",
              only_to_user: false
            )
          else
            command_event.respond_with(
              'That model is currently unavailable. Try running ' \
              "`/model pull #{requested_model}` first"
            )
          end
        end
      end
    end
  end
end

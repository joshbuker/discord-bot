module DiscordBot
  module Commands
    class Model < Base
      class << self
        def description
          'Make changes to the LLM Model'
        end

        def register
          Bot.register_command(command_name, description) do |command|
            command.subcommand(:reset, 'Reset to the default model')
            command.subcommand(:pull, 'Fetch a new model for future use') do |subcommand|
              subcommand.string(:model, 'What model to fetch', required: true)
            end
            command.subcommand(:set, 'Set the current model') do |subcommand|
              subcommand.string(:model, 'What model to use', required: true)
            end
            command.subcommand(:list, 'List the available models')
            command.subcommand(:current, 'Show the currently loaded model')
          end
        end

        def handle
          Bot.command_callback(command_name) do |event|
            run(DiscordBot::Events::Command.new(event))
          end

          Bot.command_callback(command_name).subcommand(:reset) do |event|
            reset_model(DiscordBot::Events::Command.new(event))
          end

          Bot.command_callback(command_name).subcommand(:pull) do |event|
            pull_model(DiscordBot::Events::Command.new(event))
          end

          Bot.command_callback(command_name).subcommand(:set) do |event|
            set_model(DiscordBot::Events::Command.new(event))
          end

          Bot.command_callback(command_name).subcommand(:list) do |event|
            list_available_models(DiscordBot::Events::Command.new(event))
          end

          Bot.command_callback(command_name).subcommand(:current) do |event|
            print_current_model(DiscordBot::Events::Command.new(event))
          end
        end

        def run(command)
          command.respond_with('Please use one of the subcommands instead')
        end

        def reset_model(command)
          Logger.info "#{command.whois} has reset the LLM model to default for #{command.channel_name}"
          Bot.reset_model(channel_id: command.channel_id)
          default_model = DiscordBot::LLM::Model.new
          command.respond_with("Reset the LLM model to default:\n#{default_model.about}", only_to_user: false)
        end

        def pull_model(command)
          unless command.ran_by_admin?
            Logger.info "#{command.whois} tried running the pull model command without permission"
            command.respond_with('Due to the large size of models, this command is restricted to admins')
            return
          end
          requested_model = command.options['model']
          Logger.info "#{command.whois} has requested the LLM model #{requested_model}"
          command.respond_with("Pulling LLM model \"#{requested_model}\"...")
          model = DiscordBot::LLM::Model.new(model_name: requested_model)
          if model.available?
            command.update_response("\"#{requested_model}\" is already available")
          else
            begin
              model.pull
              command.update_response("Pulled LLM model \"#{requested_model}\"")
            rescue DiscordBot::Errors::FailedToPullModel
              command.update_response("Failed to pull LLM model \"#{requested_model}\"")
            end
          end
        rescue DiscordBot::Errors::PermissionDenied => error
          Logger.warn error.message
        end

        def set_model(command)
          requested_model = command.options['model']
          model = DiscordBot::LLM::Model.new(model_name: requested_model)
          if model.available?
            Logger.info "#{command.whois} has set the LLM model to #{requested_model} for \##{command.channel_name}"
            Bot.set_model(channel_id: command.channel_id, model: model)
            command.respond_with("Set LLM model to:\n\"#{model.about}\"", only_to_user: false)
          else
            command.respond_with("That model is currently unavailable. Try running `/model pull #{requested_model}` first")
          end
        end

        def print_current_model(command)
          Logger.info "#{command.whois} inspected the current model"
          model = Bot.current_model(channel_id: command.channel_id)
          command.respond_with("The currently loaded model for \##{command.channel_name} is:\n#{model.about}")
        end

        def list_available_models(command)
          Logger.info "#{command.whois} requested a list of the available models"
          models = DiscordBot::LLM::Model.available_models
          # TODO: Also show file size, parameter size, and quantization level
          formatted_list = models.map{ |model| "- #{model.about}" }.join("\n")
          command.respond_with("The currently available models are:\n#{formatted_list}\n\nMore can be found at: https://ollama.com/library")
        end
      end
    end
  end
end

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
        end

        def run(command)
          command.respond_with('Please use one of the subcommands instead')
        end

        def reset_model(command)
          # Bot.reset_model(channel_id: command.channel_id)
          command.respond_with('Pending implementation')
        end

        def pull_model(command)
          unless command.ran_by_admin?
            raise DiscordBot::Errors::PermissionDenied,
              "#{command.user.name} tried running the pull model command without permission"
          end
          requested_model = command.options['model']
          Logger.info "#{command.user.name} has requested the LLM model #{requested_model}"
          command.respond_with('Pending implementation')
        rescue DiscordBot::Errors::PermissionDenied => error
          Logger.warn error.message
        end

        def set_model(command)
          command.respond_with('Pending implementation')
        end
      end
    end
  end
end

module DiscordBot
  module Commands
    class LLM < Base
      class << self
        def description
          'Make changes to the LLM'
        end

        def register
          Bot.register_command(command_name, description) do |command|
            command.subcommand_group(:model, 'Adjust the model') do |group|
              group.subcommand('reset', 'Reset to the default model')
              group.subcommand('pull', 'Fetch a new model for future use') do |subcommand|
                subcommand.string('model', 'What model to fetch', required: true)
              end
              group.subcommand('set', 'Set the current model') do |subcommand|
                subcommand.string('model', 'What model to use', required: true)
              end
            end

            command.subcommand_group(:system_prompt, 'Adjust the system prompt') do |group|
              group.subcommand('reset', 'Reset to the default system prompt') do |subcommand|
                subcommand.boolean('reset_history', 'Should the conversation history be reset?')
              end
              group.subcommand('set', 'Set the system prompt to something new') do |subcommand|
                subcommand.string('system_prompt', 'What system prompt to use', required: true)
                subcommand.boolean('reset_history', 'Should the conversation history be reset?')
              end
            end
          end
        end

        def handle
          Bot.command_group(command: command_name, group: :model) do |group|
            group.subcommand('reset') do |event|
              reset_model(DiscordBot::Events::Command.new(event))
            end

            group.subcommand('pull') do |event|
              pull_model(DiscordBot::Events::Command.new(event))
            end

            group.subcommand('set') do |event|
              set_model(DiscordBot::Events::Command.new(event))
            end
          end

          Bot.command_group(command: command_name, group: :system_prompt) do |group|
            group.subcommand('reset') do |event|
              reset_system_prompt(DiscordBot::Events::Command.new(event))
            end

            group.subcommand('set') do |event|
              set_system_prompt(DiscordBot::Events::Command.new(event))
            end
          end
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

        def reset_system_prompt(command)
          Bot.reset_system_prompt(channel_id: command.channel_id)
        end
      end
    end
  end
end

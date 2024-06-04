module DiscordBot
  module Commands
    module Slash
      ##
      # Provides commands for interacting with the system prompt for the LLM.
      #
      class SystemPrompt < Base
        class << self
          def description
            'Adjust the LLM System Prompt'
          end

          def register
            Bot.register_command(command_name, description) do |command|
              command.subcommand(:reset, 'Reset to the default system prompt') do |subcommand|
                subcommand.boolean(:reset_history, 'Should the conversation history be reset?')
              end
              command.subcommand(:set, 'Set the system prompt to something new') do |subcommand|
                subcommand.string(:system_prompt, 'What system prompt to use', required: true)
                subcommand.boolean(:reset_history, 'Should the conversation history be reset?')
              end
            end
          end

          def handle
            Bot.command_callback(command_name) do |event|
              run(DiscordBot::Events::Command.new(event))
            end

            Bot.command_callback(command_name).subcommand(:reset) do |event|
              reset_system_prompt(DiscordBot::Events::Command.new(event))
            end

            Bot.command_callback(command_name).subcommand(:set) do |event|
              set_system_prompt(DiscordBot::Events::Command.new(event))
            end
          end

          def run(command)
            command.respond_with('Please use one of the subcommands instead')
          end

          def reset_system_prompt(command)
            default_prompt = Bot.reset_system_prompt(
              channel_id: command.channel_id
            )
            command.respond_with(
              "System prompt reset to default:\n\n#{default_prompt}",
              only_to_user: false
            )
          end

          # rubocop:disable Naming/AccessorMethodName
          def set_system_prompt(command)
            system_prompt = command.options['system_prompt']
            Bot.set_channel_system_prompt(
              channel_id:    command.channel_id,
              system_prompt: system_prompt
            )
            command.respond_with(
              "System prompt has been reset to:\n\n#{system_prompt}",
              only_to_user: false
            )
          end
          # rubocop:enable Naming/AccessorMethodName
        end
      end
    end
  end
end

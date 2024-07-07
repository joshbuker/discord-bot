module DiscordBot
  module Subcommands
    module SystemPrompt
      class Set < DiscordBot::Subcommand
        def description
          'Set the system prompt to something new'
        end

        def register_options(options)
          options.string(:system_prompt, 'What system prompt to use', required: true)
          options.boolean(:reset_history, 'Should the conversation history be reset?')
        end

        def run(command_event)
          system_prompt = command_event.options['system_prompt']
          logger.info(
            "System prompt for channel #{command_event.channel_name} has " \
            "been reset to:\n#{system_prompt}"
          )
          bot.conversation(command_event.channel_id).system_prompt =
            system_prompt
          if command_event.options['reset_history']
            bot.conversation(command_event.channel_id).reset_history
          end
          command_event.respond_with(
            "System prompt has been reset to:\n\n#{system_prompt}",
            only_to_user: false
          )
        end
      end
    end
  end
end

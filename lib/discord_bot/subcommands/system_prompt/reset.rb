module DiscordBot
  module Subcommands
    module SystemPrompt
      class Reset < DiscordBot::Subcommand
        def description
          'Reset to the default system prompt'
        end

        def register_options(options)
          options.boolean(:reset_history, 'Should the conversation history be reset?')
        end

        def run(command_event)
          logger.info(
            "System prompt for channel #{command_event.channel_name} has " \
            'been reset to default'
          )
          default_prompt =
            bot.conversation(command_event.channel_id).reset_system_prompt
          if command_event.options['reset_history']
            bot.conversation(command_event.channel_id).reset_history
          end
          command_event.respond_with(
            "System prompt reset to default:\n\n#{default_prompt}",
            only_to_user: false
          )
        end
      end
    end
  end
end

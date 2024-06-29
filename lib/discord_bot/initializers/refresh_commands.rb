module DiscordBot
  module Initializers
    class RefreshCommands < DiscordBot::Initializer
      def run?
        !bot.config.fast_boot
      end

      def setup
        logger.info 'Refreshing bot commands'
        delete_unused_commands
        register_commands
      end

      private

      # TODO: Delete leftovers when switching a command to/from server and global
      def delete_unused_commands
        logger.info 'Deleting unused commands'
        existing_commands = bot.discord_bot.get_application_commands
        commands_to_delete(existing_commands).each do |command|
          logger.info "Command \"/#{command.name}\" is unused, deleting"
          bot.discord_bot.delete_application_command(command.id)
        end
      end

      def register_commands
        logger.info 'Registering commands'
        bot.commands.each(&:register)
      end

      def commands_to_delete(existing_commands)
        commands_to_keep = bot.commands.map(&:command_name)
        existing_commands.reject do |command|
          commands_to_keep.include?(command.name) ||
          commands_to_keep.include?(command.name.to_sym)
        end
      end
    end
  end
end

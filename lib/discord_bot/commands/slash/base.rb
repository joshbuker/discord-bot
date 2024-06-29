module DiscordBot
  module Commands
    module Slash
      ##
      # Base class for slash commands
      #
      class Base
        attr_reader :bot, :logger

        def initialize(bot)
          @bot = bot
          @logger = bot.logger
        end

        def register
          logger.debug "Registering /#{command_name} command"
          bot.discord_bot.register_application_command(
            command_name,
            description
          ) do |command|
            register_subcommands(command)
            register_options(command)
          end
        end

        def handle
          if subcommands.any?
            handle_subcommands
          else
            handle_base_command
          end
        end

        def run(command_event)
          raise NotImplementedError
        end

        def subcommands
          []
        end

        def command_name
          name.demodulize.underscore.to_sym
        end

        def description
          'Description not set for this command'
        end

        # TODO: If servers.any?, register as server command instead of application command
        def servers
          []
        end

        protected

        def register_subcommands(command)
          subcommands.each do |subcommand|
            subcommand.register(command)
          end
        end

        def register_options(options); end

        def handle_subcommands
          subcommands.each(&:handle)
        end

        def handle_base_command
          logger.debug "Registering /#{command_name} command callback"
          bot.discord_bot.application_command(command_name) do |event|
            run(DiscordBot::Events::Command.new(event))
          end
        end

        def require_admin!(command_event, reason = '')
          return if command_event.ran_by_admin?

          logger.warn(
            "#{command_event.whois} tried running the " \
            "/#{command_event.command_name} command without permission"
          )
          if reason.present?
            command_event.respond_with(reason)
          else
            command_event.respond_with(
              'This command is restricted to admins!'
            )
          end
          yield
        end
      end
    end
  end
end

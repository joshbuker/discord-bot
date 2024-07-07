module DiscordBot
  module Commands
    module User
      ##
      # Base class for User commands.
      #
      class Base < DiscordBot::Command
        def register
          logger.debug "Registering \"#{command_name}\" user command"
          bot.discord_bot.register_application_command(
            command_name,
            nil,
            type: :user
          )
        end

        def handle
          logger.debug "Registering \"#{command_name}\" user command callback"
          bot.discord_bot.application_command(command_name.to_sym) do |event|
            run(DiscordBot::Events::Command.new(event))
          end
        end

        def run(command_event)
          raise NotImplementedError
        end

        def command_name
          self.class.name.demodulize.titlecase
        end

        protected

        attr_reader :bot

        def require_admin!(command_event, reason = '')
          return if command_event.ran_by_admin?(bot)

          logger.warn(
            "#{command_event.whois} tried running the " \
            "#{command_event.command_name} command without permission"
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

module DiscordBot
  module Commands
    module Message
      ##
      # Provides a base class for message commands.
      #
      class Base
        def initialize(bot)
          @bot = bot
        end

        def register
          logger.debug "Registering \"#{command_name}\" message command"
          bot.discord_bot.register_application_command(
            command_name,
            type: :message
          )
        end

        def handle
          logger.debug(
            "Registering \"#{command_name}\" message command callback"
          )
          bot.discord_bot.application_command(command_name.to_sym) do |event|
            run(DiscordBot::Events::Command.new(event))
          end
        end

        def run(command_event)
          raise NotImplementedError
        end

        def command_name
          name.demodulize.titlecase
        end

        protected

        attr_reader :bot
      end
    end
  end
end

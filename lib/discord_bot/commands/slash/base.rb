module DiscordBot
  module Commands
    module Slash
      ##
      # Base class for slash commands
      #
      class Base
        class << self
          def register
            # Logger.info "Registering #{command_name} command"
            Bot.register_command(command_name, description)
          end

          def handle
            # Logger.info "Registering #{command_name} command callback"
            Bot.command_callback(command_name) do |event|
              run(DiscordBot::Events::Command.new(event))
            end
          end

          def run(command)
            raise NotImplementedError
          end

          def command_name
            name.demodulize.underscore.to_sym
          end

          def description
            'Description unavailable for this command'
          end
        end
      end
    end
  end
end

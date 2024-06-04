module DiscordBot
  module Commands
    ##
    # Provides a base class for message commands.
    #
    # TODO: Use modules instead of classes for different types of commands?
    #
    class MessageCommand < Base
      class << self
        def register
          # Logger.info "Registering #{command_name} command"
          Bot.register_message_command(command_name)
        end

        def handle
          # Logger.info "Registering #{command_name} command callback"
          Bot.command_callback(command_name.to_sym) do |event|
            run(DiscordBot::Events::Command.new(event))
          end
        end

        def command_name
          name.demodulize.titlecase
        end
      end
    end
  end
end

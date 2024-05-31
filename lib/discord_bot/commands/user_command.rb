module DiscordBot
  module Commands
    class UserCommand < Base
      class << self
        def register
          # Logger.info "Registering #{command_name} command"
          Bot.register_user_command(command_name)
        end

        def handle
          # Logger.info "Registering #{command_name} command callback"
          Bot.command_callback(command_name.to_sym) do |event|
            run(DiscordBot::Events::Command.new(event))
          end
        end

        def command_name
          self.name.demodulize.titlecase
        end
      end
    end
  end
end

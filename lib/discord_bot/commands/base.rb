require 'active_support/inflector'

module DiscordBot
  module Commands
    class Base
      def initialize(bot:)
        @bot = bot
      end

      def register(server_id: nil)
        if server_id
          @bot.register_application_command(name, description, server_id: server_id)
        else
          @bot.register_application_command(name, description)
        end
      end

      def handle
        @bot.application_command(name) do |event|
          run(DiscordBot::CommandRun.new(event))
        end
      end

      def run(command_run)
        raise NotImplementedError
      end

      def name
        self.class.name.demodulize.underscore.to_sym
      end

      def description
        'Description unavailable for this command'
      end
    end
  end
end

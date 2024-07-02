module DiscordBot
  class Subcommand
    attr_reader :bot, :base_command, :logger

    def initialize(base_command)
      @base_command = base_command
      @bot = base_command.bot
      @logger = base_command.logger
    end

    def register(command)
      logger.debug(
        "Registering /#{command.command_name} #{command_name} subcommand"
      )
      command.subcommand(command_name, description) do |options|
        register_options(options)
      end
    end

    def register_options(options); end

    def handle
      bot.discord_bot.application_command(base_command.command_name).subcommand(
        command_name
      ) do |event|
        run(DiscordBot::Events::Command.new(event))
      end
    end

    def run(command_event)
      raise NotImplementedError
    end

    def command_name
      self.class.name.demodulize.underscore.to_sym
    end

    def description
      'Description not set for this command'
    end

    protected

    # FIXME: This method should not live here
    def connected_to_voice?(voice_channel)
      return false unless voice_channel.present?

      bot.discord_bot.voice(voice_channel.id).present?
    end

    def require_admin!(command, reason = '')
      unless command.ran_by_admin?
        logger.warn(
          "#{command.whois} tried running the #{command.command_name} " \
          'command without permission'
        )
        if reason.present?
          command.respond_with(reason)
        else
          command.respond_with('This command is restricted to admins!')
        end
        yield
      end
    end
  end
end

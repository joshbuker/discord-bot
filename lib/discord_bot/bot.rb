module DiscordBot
  # FIXME: This class is big and unwieldy, and should probably be broken up some more
  class Bot
    attr_reader :message_handler, :commands

    # Class Methods

    class << self
      def instance
        @instance ||= new
      end

      def shutdown
        instance.shutdown
      end

      def run
        instance.run
      end

      def user
        instance.user
      end

      def voice(identifier)
        instance.voice(identifier)
      end

      def voice_connect(channel)
        instance.voice_connect(channel)
      end

      def find_user_by_id(id)
        instance.find_user_by_id(id)
      end

      def register_command(name, description, &block)
        instance.register_command(name, description, &block)
      end

      def command_group(command:, group:, &block)
        instance.command_group(command: command, group: group, &block)
      end

      def command_callback(name, &block)
        instance.application_command(name, &block)
      end

      def reset_model(channel_id:)
        instance.reset_model(channel_id: channel_id)
      end

      def set_model(channel_id:, model:)
        instance.set_model(channel_id: channel_id, model: model)
      end

      def reset_system_prompt(channel_id:)
        instance.reset_system_prompt(channel_id: channel_id)
      end

      def set_channel_system_prompt(channel_id:,system_prompt:)
        instance.set_channel_system_prompt(
          channel_id: channel_id,
          system_prompt: system_prompt
        )
      end
    end

    # Instance Methods

    def initialize
      @bot = Discordrb::Bot.new(
        token: Config.discord_bot_token,
        intents: Config.discord_bot_intents
      )
      @channel_conversations = {}
      @channel_models = {}
      @commands = [
        DiscordBot::Commands::Exit,
        DiscordBot::Commands::Help,
        DiscordBot::Commands::Model,
        DiscordBot::Commands::Source,
        DiscordBot::Commands::Tuturu,
        DiscordBot::Commands::SystemPrompt
      ]
    end

    def run(skip_motd: false, fast_boot: false)
      Logger.info 'Initializing bot'
      unless fast_boot
        pull_default_model
        delete_unused_commands
        register_commands
      end
      initialize_callbacks
      motd unless skip_motd
      # at_exit { @bot.stop }
      Logger.info 'Starting bot'
      @bot.run(true)
      Logger.info 'Bot running'
      @bot.join
    end

    def delete_unused_commands
      Logger.info 'Deleting unused commands'
      existing_commands = @bot.get_application_commands
      commands_to_delete(existing_commands).each do |command|
        Logger.info "Command \"/#{command.name}\" is unused, deleting"
        @bot.delete_application_command(command.id)
      end

      # Config.slash_command_server_ids.each do |server_id|
      #   existing_commands = @bot.get_application_commands(server_id: server_id)
      #   commands_to_delete(existing_commands).each do |command|
      #     @bot.delete_application_command(command.id, server_id: server_id)
      #   end
      # end
    end

    def motd
      Logger.info "Bot Invite URL: #{@bot.invite_url}"
    end

    def bot
      @bot
    end

    def find_user_by_id(id)
      @bot.user(id)
    end

    def user
      @bot.bot_user
    end

    def message_callback(&block)
      @bot.message(&block)
    end

    def voice(identifier)
      @bot.voice(identifier)
    end

    def voice_connect(channel)
      @bot.voice_connect(channel)
    end

    def application_command(name, &block)
      @bot.application_command(name, &block)
    end

    def command_group(command:, group:, &block)
      @bot.application_command(command).group(group, &block)
    end

    def register_command(name, description, &block)
      @bot.register_application_command(name, description, &block)
    end

    def shutdown
      Logger.info 'Shutting down'
      @bot.stop
    end

    def reset_system_prompt(channel_id:)
      Logger.info("System prompt for channel #{channel_id} has been reset to default")
      conversation(channel_id).reset_system_prompt
    end

    def set_channel_system_prompt(channel_id:,system_prompt:)
      Logger.info("System prompt for channel #{channel_id} has been reset to:\n#{system_prompt}")
      conversation(channel_id).set_system_prompt(system_prompt: system_prompt)
    end

    def reset_model(channel_id:)
      set_model(channel_id: channel_id, model: DiscordBot::LLM::Model.new)
    end

    def set_model(channel_id:, model:)
      unless model.is_a?(DiscordBot::LLM::Model)
        raise ArgumentError,
          "Tried to set model using invalid class type #{model.class.name}"
      end

      unless model.available?
        raise ArgumentError, "Tried to set model, but it's unavailable"
      end

      @channel_models[channel_id] = model
    end

    private

    def conversation(channel_id)
      @channel_conversations[channel_id] ||= DiscordBot::LLM::Conversation.new
    end

    def model(channel_id)
      @channel_models[channel_id] ||= DiscordBot::LLM::Model.new
    end

    def pull_default_model
      Logger.info 'Pulling default LLM model'
      begin
        DiscordBot::LLM::Model.new(model_name: DiscordBot::LLM::DEFAULT_MODEL).pull
      rescue DiscordBot::Errors::FailedToPullModel => error
        Logger.fatal error.message
        shutdown
      end
    end

    def register_commands
      Logger.info 'Registering commands'
      commands.each do |command|
        command.register
      end
    end

    def handle_message(message)
      Logger.info "Message received (#{message.from}):\n#{message.content}"
      if message.content.start_with?('!prompt ')
        set_system_prompt_from_chat(message)
      elsif message.content.include?('(╯°□°)╯︵ ┻━┻')
        fix_table(message)
      elsif message.addressed_to_bot?
        reply_to_message(message)
      else
        no_action(message)
      end
    end

    def set_system_prompt_from_chat(message)
      system_prompt = message.content.sub('!prompt ', '')
      set_channel_system_prompt(
        channel_id: message.channel_id,
        system_prompt: system_prompt
      )
      message.reply_with("System prompt has been reset to:\n\n#{system_prompt}")
    end

    def fix_table(message)
      message.reply_with("┬─┬ノ( º _ ºノ)\nSo uncivilized!")
    end

    def reply_to_message(message)
      channel_id = message.channel_id
      typing_thread = message.start_typing_thread
      response = DiscordBot::LLM::Response.new(
        conversation_history: conversation(channel_id),
        user_message: message,
        model: model(channel_id)
      )
      typing_thread.exit
      Logger.info "Reply sent (#{response.model.name}):\n#{response.message}"
      message.reply_with(response.message)
    end

    def no_action(message)
      Logger.info 'No action needed'
    end

    def initialize_callbacks
      Logger.info 'Initializing callbacks'
      message_callback do |event|
        handle_message(DiscordBot::Events::Message.new(event))
      end

      commands.each do |command|
        command.handle
      end
    end

    def commands_to_delete(existing_commands)
      commands_to_keep = commands.map(&:command_name)
      existing_commands.reject do |command|
        commands_to_keep.include?(command.name.to_sym)
      end
    end
  end
end

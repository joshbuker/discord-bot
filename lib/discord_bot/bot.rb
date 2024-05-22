require 'discordrb'
require 'byebug'
require 'opus-ruby'

module DiscordBot
  class Bot
    SLASH_COMMAND_SERVER_IDS = [
      933463011551764550,
      1237136024573051053
    ]
    attr_reader :message_responder, :commands

    def initialize(discord_bot_token:,refresh_commands: true)
      Logger.log 'Initializing bot, please wait...'
      @bot = Discordrb::Bot.new(
        token: discord_bot_token,
        intents: :all
        # intents: [:server_messages]
      )
      @message_responder = MessageResponder.new(bot: self)
      @commands = [
        DiscordBot::Commands::Exit.new(bot: self),
        DiscordBot::Commands::Help.new(bot: self),
        DiscordBot::Commands::Source.new(bot: self),
        DiscordBot::Commands::Tuturu.new(bot: self)
      ]

      pull_models

      if refresh_commands
        Logger.log 'Registering commands...'
        register_commands
        # TODO: Remove unused commands
      else
        Logger.log 'Skipping command refresh...'
      end
      Logger.log 'Initializing callbacks...'
      initialize_callbacks
    end

    def run(skip_motd: false)
      Logger.log "Bot Invite URL: #{@bot.invite_url}" unless skip_motd
      at_exit { @bot.stop }
      Logger.log 'Starting bot...'
      @bot.run(true)
      Logger.log 'Bot running...'
      @bot.join
    end

    def user
      @bot.bot_user
    end

    def message(&)
      @bot.message(&)
    end

    def voice(identifier)
      @bot.voice(identifier)
    end

    def voice_connect(channel)
      @bot.voice_connect(channel)
    end

    def application_command(name, &)
      @bot.application_command(name, &)
    end

    def register_application_command(name, description, server_id: nil)
      @bot.register_application_command(name, description, server_id: server_id)
    end

    def shutdown
      @bot.stop # FIXME: Redundant?
      exit
    end

    private

    def pull_models
      Logger.log('Pulling Models (this may take a while)...')
      pull_model(model_name: DiscordBot::LLM_MODEL)
      Logger.log('Models loaded...')
    end

    def pull_model(model_name:)
      payload = { name: model_name, stream: false }.to_json
      headers = headers = {
        content_type: :json,
        accept: :json
      }
      DiscordBot::Request.post('/api/pull', payload, headers)
    rescue StandardError => error
      Logger.log("Model pull failed due to: \"#{error.message}\", exiting...")
      shutdown
    end

    def register_commands(global_command_registration: false)
      if global_command_registration
        # Register global commands (delayed)
        commands.each do |command|
          command.register
        end
      else
        # Register server specific commands (instant)
        SLASH_COMMAND_SERVER_IDS.each do |server_id|
          commands.each do |command|
            command.register(server_id: server_id)
          end
        end
      end
    end

    def initialize_callbacks
      message_responder.handle

      commands.each do |command|
        command.handle
      end
    end
  end
end

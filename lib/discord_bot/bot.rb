module DiscordBot
  ##
  # Initializes the bot, and is the general entrypoint for the code.
  #
  class Bot
    attr_reader :config, :discord_bot, :logger

    def initialize(config: default_config, discord_bot: nil)
      @config = config
      @channel_conversations = {}
      @logger = DiscordBot::Logger.new(self)
      @discord_bot = discord_bot || Discordrb::Bot.new(
        token: config.discord_bot_token || 'invalid',
        intents: config.discord_bot_intents
      )
    end

    def conversation(channel_id)
      @channel_conversations[channel_id] ||= DiscordBot::Conversation.new(self)
    end

    def commands
      @commands ||= DiscordBot::Commands.all_commands(self)
    end

    def run
      setup_bot
      start_bot
    rescue Interrupt
      shutdown
    end

    private

    def setup_bot
      logger.info 'Initializing bot'
      initializers.each(&:init)
    end

    # HACK: This feels a bit sussy
    def initializers
      [
        DiscordBot::Initializers::PullDefaultModels.new(self),
        DiscordBot::Initializers::RefreshCommands.new(self),
        DiscordBot::Initializers::InitializeCallbacks.new(self),
        DiscordBot::Initializers::MessageOfTheDay.new(self)
      ]
    end

    def start_bot
      logger.info 'Starting bot'
      discord_bot.run(true)
      logger.info 'Bot running'
      discord_bot.join
    end

    def shutdown
      logger.info 'Shutting down'
      discord_bot.stop
    end

    def default_config
      DiscordBot::Config.new
    end
  end
end

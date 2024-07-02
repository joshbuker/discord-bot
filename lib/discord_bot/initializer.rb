module DiscordBot
  class Initializer
    attr_reader :bot, :logger

    def initialize(bot)
      @bot = bot
      @logger = bot.logger
    end

    def run?
      true
    end

    def init
      setup if run?
    end

    def setup
      raise NotImplementedError
    end
  end
end

module DiscordBot
  class Initializer
    attr_reader :bot

    def initialize(bot)
      @bot = bot
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

module DiscordBot
  class Command
    attr_reader :bot, :logger

    def initialize(bot)
      @bot = bot
      @logger = bot.logger
    end
  end
end

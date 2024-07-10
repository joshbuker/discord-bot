require_relative '../lib/discord_bot'

config = DiscordBot::Config.new(fast_boot: true)
# config = DiscordBot::Config.new
bot = DiscordBot::Bot.new(config: config)
bot.run

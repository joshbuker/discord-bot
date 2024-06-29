require_relative '../lib/discord_bot'

# trap('INT') { DiscordBot::Bot.shutdown }
config = DiscordBot::Config.new(fast_boot: true)
bot = DiscordBot::Bot.new(config: config)
bot.run

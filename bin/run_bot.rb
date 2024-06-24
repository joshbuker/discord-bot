require_relative '../lib/discord_bot'

# trap('INT') { DiscordBot::Bot.shutdown }
DiscordBot::Bot.run

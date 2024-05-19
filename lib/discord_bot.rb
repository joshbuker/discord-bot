# frozen_string_literal: true

##
# A simple Discord bot written using Ruby. It provides various commands and will
# eventually include LLM responses to questions directed towards it.
#
module DiscordBot
  autoload :Bot, './discord_bot/bot'
  autoload :Logger, './discord_bot/logger'
  autoload :VERSION, './discord_bot/version'
end

discord_bot = DiscordBot::Bot.new(
  discord_bot_token: ENV['RUBY_DISCORD_BOT_TOKEN']
)
discord_bot.run

$LOAD_PATH.unshift(File.dirname(__FILE__))

##
# A simple Discord bot written using Ruby. It provides various commands and will
# eventually include LLM responses to questions directed towards it.
#
module DiscordBot
  autoload :Bot, 'discord_bot/bot'
  autoload :CommandRun, 'discord_bot/command_run'
  autoload :ConversationHistory, 'discord_bot/conversation_history'
  autoload :Error, 'discord_bot/errors'
  autoload :Errors, 'discord_bot/errors'
  autoload :Logger, 'discord_bot/logger'
  autoload :MessageResponder, 'discord_bot/message_responder'
  autoload :ModelResponse, 'discord_bot/model_response'
  autoload :UserMessage, 'discord_bot/user_message'
  autoload :VERSION, 'discord_bot/version'

  module Commands
    autoload :Base, 'discord_bot/commands/base'
    autoload :Exit, 'discord_bot/commands/exit'
    autoload :Help, 'discord_bot/commands/help'
    autoload :Source, 'discord_bot/commands/source'
    autoload :Tuturu, 'discord_bot/commands/tuturu'
  end
end

discord_bot = DiscordBot::Bot.new(
  discord_bot_token: ENV['RUBY_DISCORD_BOT_TOKEN'],
  refresh_commands: false
)
discord_bot.run

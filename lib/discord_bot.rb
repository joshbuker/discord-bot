$LOAD_PATH.unshift(File.dirname(__FILE__))

# Provide extensions such as .present?
require 'active_support/all'
# Allow for easy debugging with `byebug`
require 'byebug'
# Discord API
require 'discordrb'
# Allow joining voice channels
require 'opus-ruby'
# Sanitize YouTube URLs
require 'shellwords'
# Validate YouTube URLs
require 'uri'

# Monkey patches are great and never go wrong
class Integer
  def to_human_filesize
    ActiveSupport::NumberHelper.number_to_human_size(self)
  end
end

##
# A simple Discord bot written using Ruby. It provides various commands and will
# eventually include LLM responses to questions directed towards it.
#
module DiscordBot
  module Commands
    autoload :Base,         'discord_bot/commands/base'
    autoload :Exit,         'discord_bot/commands/exit'
    autoload :Help,         'discord_bot/commands/help'
    autoload :Model,        'discord_bot/commands/model'
    autoload :Source,       'discord_bot/commands/source'
    autoload :SystemPrompt, 'discord_bot/commands/system_prompt'
    autoload :Voice,        'discord_bot/commands/voice'
  end

  module Events
    autoload :Base,    'discord_bot/events/base'
    autoload :Command, 'discord_bot/events/command'
    autoload :Message, 'discord_bot/events/message'
  end

  module LLM
    API_PROTOCOL  = ENV['OLLAMA_SERVICE_PROTOCOL'] || "http://"
    API_HOST      = ENV['OLLAMA_SERVICE_NAME'] || 'localhost'
    API_PORT      = ENV['OLLAMA_SERVICE_PORT'] || '11434'
    API_URL       = API_PROTOCOL + API_HOST + ':' + API_PORT
    DEFAULT_MODEL = ENV['DEFAULT_LLM_MODEL'] || 'llama3'

    autoload :ApiRequest,   'discord_bot/llm/api_request'
    autoload :Conversation, 'discord_bot/llm/conversation'
    autoload :Model,        'discord_bot/llm/model'
    autoload :Response,     'discord_bot/llm/response'
  end

  autoload :Bot,    'discord_bot/bot'
  autoload :Config, 'discord_bot/config'
  autoload :Error,  'discord_bot/errors'
  autoload :Errors, 'discord_bot/errors'
  autoload :Logger, 'discord_bot/logger'
  autoload :User,   'discord_bot/user'
  # autoload :VERSION, 'discord_bot/version'
end

# trap('INT') { DiscordBot::Bot.shutdown }
DiscordBot::Bot.run

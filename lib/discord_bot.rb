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
# Allow processing Base64 images as files without needing to write to disk
require 'stringio'

# Monkey patches are great and never go wrong
class Integer
  def to_human_filesize
    ActiveSupport::NumberHelper.number_to_human_size(self)
  end
end

##
# A Discord Bot written Ruby. Currently supports LLM responses in chat, along
# with slash commands for modifying the LLM and interacting in voice chat.
#
module DiscordBot
  ##
  # Commands that can be ran manually, as opposed to the automatic responses to
  # messages.
  #
  module Commands
    ##
    # Message commands that take no parameters, but include the message that the
    # command was ran against.
    #
    module Message
      autoload :Base,           'discord_bot/commands/message/base'
      autoload :ReplyToMessage, 'discord_bot/commands/message/reply_to_message'
    end

    ##
    # Slash commands that can be ran from chat, and can take parameters/options.
    #
    # Examples include:
    # - `/source`
    # - `/model list`
    # - `/voice youtube <url>`
    #
    module Slash
      autoload :Base,         'discord_bot/commands/slash/base'
      autoload :Exit,         'discord_bot/commands/slash/exit'
      autoload :Help,         'discord_bot/commands/slash/help'
      autoload :NiceMessage,  'discord_bot/commands/slash/nice_message'
      autoload :Image,        'discord_bot/commands/slash/image'
      autoload :Model,        'discord_bot/commands/slash/model'
      autoload :Source,       'discord_bot/commands/slash/source'
      autoload :SystemPrompt, 'discord_bot/commands/slash/system_prompt'
      autoload :UserCommand,  'discord_bot/commands/slash/user_command'
      autoload :Voice,        'discord_bot/commands/slash/voice'
    end

    ##
    # User commands that take no parameters, but include the user that the
    # command was ran against.
    #
    module User
      autoload :Base,        'discord_bot/commands/user/base'
      autoload :HelloFriend, 'discord_bot/commands/user/hello_friend'
    end
  end

  ##
  # Lightweight wrappers for the callback response objects from Discord events.
  #
  module Events
    autoload :Base,    'discord_bot/events/base'
    autoload :Command, 'discord_bot/events/command'
    autoload :Message, 'discord_bot/events/message'
  end

  ##
  # Contains everything needed to interact with the LLM via Ollama.
  #
  module LLM
    API_PROTOCOL  = ENV['OLLAMA_SERVICE_PROTOCOL'] || 'http://'
    API_HOST      = ENV['OLLAMA_SERVICE_NAME'] || 'localhost'
    API_PORT      = ENV['OLLAMA_SERVICE_PORT'] || '11434'
    API_URL       = "#{API_PROTOCOL}#{API_HOST}:#{API_PORT}".freeze
    DEFAULT_MODEL = ENV['DEFAULT_LLM_MODEL'] || 'llama3'

    autoload :ApiRequest,   'discord_bot/llm/api_request'
    autoload :Conversation, 'discord_bot/llm/conversation'
    autoload :Model,        'discord_bot/llm/model'
    autoload :Response,     'discord_bot/llm/response'
  end

  ##
  # Contains everything needed to interact with Stable Diffusion via
  # Automatic1111 api.
  #
  module StableDiffusion
    API_PROTOCOL  = ENV['STABLE_DIFFUSION_SERVICE_PROTOCOL'] || 'http://'
    API_HOST      = ENV['STABLE_DIFFUSION_SERVICE_NAME'] || 'localhost'
    API_PORT      = ENV['STABLE_DIFFUSION_SERVICE_PORT'] || '7860'
    API_URL       = "#{API_PROTOCOL}#{API_HOST}:#{API_PORT}".freeze

    autoload :ApiRequest,   'discord_bot/stable_diffusion/api_request'
    autoload :ImageOptions, 'discord_bot/stable_diffusion/image_options'
    autoload :Image,        'discord_bot/stable_diffusion/image'
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

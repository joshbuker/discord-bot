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
  # A wrapper around the API to provide REST requests for things such as GenAI
  # responses.
  #
  module Api
    module Services
      autoload :Automatic1111, 'discord_bot/api/services/automatic1111'
      autoload :MeloTTS,       'discord_bot/api/services/melotts'
      autoload :Ollama,        'discord_bot/api/services/ollama'
    end

    autoload :Interface, 'discord_bot/api/interface'
    autoload :Service,   'discord_bot/api/service'
  end

  ##
  # Commands that can be ran manually, as opposed to the automatic responses to
  # messages.
  #
  module Commands
    # REVIEW: Is this file the best place for these methods to live?
    def self.all_commands(bot)
      [
        DiscordBot::Commands::Message.all_commands(bot),
        DiscordBot::Commands::Slash.all_commands(bot),
        DiscordBot::Commands::User.all_commands(bot)
      ].flatten
    end

    ##
    # Message commands that take no parameters, but include the message that the
    # command was ran against.
    #
    module Message
      def self.all_commands(bot)
        [
          DiscordBot::Commands::Message::ReplyToMessage.new(bot)
        ]
      end

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
      def self.all_commands(bot)
        [
          DiscordBot::Commands::Slash::Exit.new(bot),
          DiscordBot::Commands::Slash::Help.new(bot),
          DiscordBot::Commands::Slash::Image.new(bot),
          DiscordBot::Commands::Slash::Model.new(bot),
          DiscordBot::Commands::Slash::NiceMessage.new(bot),
          DiscordBot::Commands::Slash::Source.new(bot),
          DiscordBot::Commands::Slash::SystemPrompt.new(bot),
          DiscordBot::Commands::Slash::Voice.new(bot)
        ]
      end

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
      def self.all_commands(bot)
        [
          DiscordBot::Commands::User::HelloFriend.new(bot)
        ]
      end

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
  # Generative AI
  #
  module GenAI
    ##
    # For providing GenAI image responses
    #
    # Contains everything needed to interact with Stable Diffusion via
    # Automatic1111 api.
    #
    module Image
      API_PROTOCOL  = ENV['STABLE_DIFFUSION_SERVICE_PROTOCOL'] || 'http://'
      API_HOST      = ENV['STABLE_DIFFUSION_SERVICE_NAME'] || 'localhost'
      API_PORT      = ENV['STABLE_DIFFUSION_SERVICE_PORT'] || '7860'
      API_URL       = "#{API_PROTOCOL}#{API_HOST}:#{API_PORT}".freeze

      autoload :Model,    'discord_bot/gen_ai/image/model'
      autoload :Options,  'discord_bot/gen_ai/image/options'
      autoload :Response, 'discord_bot/gen_ai/image/response'
    end

    ##
    # For providing GenAI text responses
    #
    # Contains everything needed to interact with the LLM via Ollama.
    #
    module Text
      API_PROTOCOL  = ENV['OLLAMA_SERVICE_PROTOCOL'] || 'http://'
      API_HOST      = ENV['OLLAMA_SERVICE_NAME'] || 'localhost'
      API_PORT      = ENV['OLLAMA_SERVICE_PORT'] || '11434'
      API_URL       = "#{API_PROTOCOL}#{API_HOST}:#{API_PORT}".freeze
      DEFAULT_MODEL = ENV['DEFAULT_LLM_MODEL'] || 'llama3'

      autoload :ChatMessage,  'discord_bot/gen_ai/text/chat_message'
      autoload :ChatHistory,  'discord_bot/gen_ai/text/chat_history'
      autoload :Model,        'discord_bot/gen_ai/text/model'
      autoload :Response,     'discord_bot/gen_ai/text/response'
    end

    ##
    # For providing GenAI voice responses
    #
    module Voice
      API_PROTOCOL  = ENV['MELOTTS_SERVICE_PROTOCOL'] || 'http://'
      API_HOST      = ENV['MELOTTS_SERVICE_NAME'] || 'localhost'
      API_PORT      = ENV['MELOTTS_SERVICE_PORT'] || '8080'
      API_URL       = "#{API_PROTOCOL}#{API_HOST}:#{API_PORT}".freeze

      autoload :Options,  'discord_bot/gen_ai/voice/options'
      autoload :Response, 'discord_bot/gen_ai/voice/response'
    end
  end

  ##
  # Initializers to setup the bot
  #
  module Initializers
    autoload :InitializeCallbacks, 'discord_bot/initializers/initialize_callbacks'
    autoload :MessageOfTheDay,     'discord_bot/initializers/message_of_the_day'
    autoload :PullDefaultModels,   'discord_bot/initializers/pull_default_models'
    autoload :RefreshCommands,     'discord_bot/initializers/refresh_commands'
  end

  module Subcommands
    module Image
      autoload :Generate, 'discord_bot/subcommands/image/generate'
    end

    module Model
      autoload :Current, 'discord_bot/subcommands/model/current'
      autoload :List,    'discord_bot/subcommands/model/list'
      autoload :Pull,    'discord_bot/subcommands/model/pull'
      autoload :Reset,   'discord_bot/subcommands/model/reset'
      autoload :Set,     'discord_bot/subcommands/model/set'
    end

    module SystemPrompt
      autoload :Current, 'discord_bot/subcommands/system_prompt/current'
      autoload :Reset,   'discord_bot/subcommands/system_prompt/reset'
      autoload :Set,     'discord_bot/subcommands/system_prompt/set'
    end

    module Voice
      autoload :Connect,    'discord_bot/subcommands/voice/connect'
      autoload :Disconnect, 'discord_bot/subcommands/voice/disconnect'
      autoload :Generate,   'discord_bot/subcommands/voice/generate'
      autoload :Speak,      'discord_bot/subcommands/voice/speak'
      autoload :Stop,       'discord_bot/subcommands/voice/stop'
      autoload :Tuturu,     'discord_bot/subcommands/voice/tuturu'
      autoload :Youtube,    'discord_bot/subcommands/voice/youtube'
    end
  end

  autoload :Bot,            'discord_bot/bot'
  autoload :Command,        'discord_bot/command'
  autoload :Config,         'discord_bot/config'
  autoload :Conversation,   'discord_bot/conversation'
  autoload :Error,          'discord_bot/errors'
  autoload :Errors,         'discord_bot/errors'
  autoload :Initializer,    'discord_bot/initializer'
  autoload :Logger,         'discord_bot/logger'
  autoload :MessageHandler, 'discord_bot/message_handler'
  autoload :Subcommand,     'discord_bot/subcommand'
  autoload :User,           'discord_bot/user'
  # autoload :VERSION, 'discord_bot/version'
end

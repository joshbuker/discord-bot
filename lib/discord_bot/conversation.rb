module DiscordBot
  class Conversation
    attr_reader :bot, :chat_history, :model

    def initialize(bot)
      @bot = bot
      @chat_history = DiscordBot::LLM::ChatHistory.new(
        bot_name: bot.config.bot_name
      )
      @model = DiscordBot::LLM::Model.new
    end

    def generate_response(message)
      raise NotImplementedError
      DiscordBot::LLM::Response.new(
        conversation_history: chat_history,
        user_message:         message,
        model:                model
      )
    end

    def reset_history
      @chat_history.reset_history
    end

    def reset_model
      @model = DiscordBot::LLM::Model.new
    end

    def reset_system_prompt
      @chat_history.reset_system_prompt
    end

    def model=(new_model)
      unless new_model.is_a?(DiscordBot::LLM::Model)
        raise ArgumentError,
          "Tried to set model using invalid class type #{new_model.class.name}"
      end

      unless new_model.available?
        raise ArgumentError, "Tried to set model, but it's unavailable"
      end

      @model = new_model
    end

    def system_prompt=(new_system_prompt)
      @chat_history.system_prompt = new_system_prompt
    end
  end
end

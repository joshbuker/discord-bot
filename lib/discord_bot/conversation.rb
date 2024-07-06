module DiscordBot
  class Conversation
    attr_reader :bot, :chat_history, :model

    def initialize(bot)
      @bot = bot
      @chat_history = DiscordBot::GenAI::Text::ChatHistory.new(
        bot_name: bot.config.bot_name
      )
      @model = DiscordBot::GenAI::Text::Model.new(bot: bot)
    end

    def generate_response(user_message)
      chat_history.append(DiscordBot::GenAI::Text::ChatMessage.new(
        role: 'user', content: parse_user_message(user_message)
      ))
      response = DiscordBot::GenAI::Text::Response.create(
        chat_history: chat_history,
        model:        model,
        bot:          bot
      )
      chat_history.append(DiscordBot::GenAI::Text::ChatMessage.new(
        role: 'assistant', content: response.message
      ))
      return response
    end

    def reset_history
      @chat_history.reset_history
    end

    def reset_model
      @model = DiscordBot::GenAI::Text::Model.new
    end

    def reset_system_prompt
      @chat_history.reset_system_prompt
    end

    def model=(new_model)
      unless new_model.is_a?(DiscordBot::GenAI::Text::Model)
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

    private

    # FIXME: This is a huge red flag, refactor it.
    def parse_user_message(user_message)
      if user_message.is_a?(String)
        user_message
      else
        "Message from #{user_message.mention} (name: #{user_message.name}):" \
        "\n\n#{user_message.content}"
      end
    end
  end
end

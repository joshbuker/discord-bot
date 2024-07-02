module DiscordBot
  module LLM
    ##
    # Processes a chat, and provides the LLM Response
    #
    class Response
      attr_reader :chat_history, :model, :bot, :logger, :body

      def self.create(chat_history:, model:, bot:)
        response = new(
          chat_history: chat_history,
          model: model,
          bot: bot
        )
        response.generate
      end

      def initialize(chat_history:, model:, bot:)
        @chat_history = chat_history
        @model = model
        @bot = bot
        @logger = bot.logger
      end

      def generate
        logger.info 'Requesting LLM Response'
        response = DiscordBot::LLM::ApiRequest.chat(
          messages:   chat_history.messages,
          model_name: model.name
        )
        @body = JSON.parse(response.body)
        self
      end

      def message
        @body['message']['content']
      end

      private

      def adjusted_user_message(user_message)
        "Message from #{user_message.mention} (name: #{user_message.name}):" \
        "\n\n#{user_message.content}"
      end
    end
  end
end

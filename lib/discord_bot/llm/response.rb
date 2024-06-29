module DiscordBot
  module LLM
    ##
    # Processes a chat, and provides the LLM Response
    #
    class Response
      # FIXME: Complexity
      # rubocop:disable Metrics/MethodLength
      def initialize(conversation_history:, user_message:, model:)
        @model = model

        if user_message.is_a?(String)
          conversation_history.append(ChatMessage.new(
            role:    'user',
            content: user_message
          ))
        else
          conversation_history.append(ChatMessage.new(
            role:    'user',
            content: adjusted_user_message(user_message)
          ))
        end

        logger.info 'Requesting LLM Response'
        response = DiscordBot::LLM::ApiRequest.chat(
          messages:   conversation_history.messages,
          model_name: model.name
        )
        @body = JSON.parse(response.body)

        conversation_history.append(ChatMessage.new(
          role:    'assistant',
          content: message
        ))
      end
      # rubocop:enable Metrics/MethodLength

      attr_reader :model

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

module DiscordBot
  module LLM
    class Response
      def initialize(conversation_history:, user_message:, model:)
        @model = model
        if user_message.is_a?(String)
          conversation_history.append(
            role: 'user',
            message: user_message
          )
        else
          conversation_history.append(
            role: 'user',
            message: adjusted_user_message(user_message)
          )
        end

        Logger.info 'Requesting LLM Response'
        response = DiscordBot::LLM::ApiRequest.chat(
          messages: conversation_history.messages,
          model_name: model.name
        )
        @body = JSON.parse(response.body)

        conversation_history.append(
          role: 'assistant',
          message: message
        )
      end

      def model
        @model
      end

      def message
        @body['message']['content']
      end

      private

      def adjusted_user_message(user_message)
        "Message from #{user_message.mention} (name: #{user_message.name}):\n\n#{user_message.content}"
      end
    end
  end
end

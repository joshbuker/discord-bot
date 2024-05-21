module DiscordBot
  class ModelResponse
    def initialize(conversation_history:, user_message:)
      @user_message = user_message

      conversation_history.append(
        role: 'user',
        message: user_message.message.content
      )

      payload = {
        model: 'llama3',
        stream: false,
        messages: conversation_history.messages,
        prompt: user_message.message.content
      }.to_json

      headers = {
        content_type: :json,
        accept: :json
      }

      @response = DiscordBot::Request.post('/api/chat', payload, headers)
      @body = JSON.parse(@response.body)

      conversation_history.append(
        role: 'assistant',
        message: message
      )
    end

    def message
      @body['message']['content']
    end
  end
end

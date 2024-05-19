module DiscordBot
  class ModelResponse
    MODEL_URL = 'http://llm:11434/api/generate'

    def initialize(user_message)
      @user_message = user_message

      url = MODEL_URL

      payload = {
        model: 'llama3',
        stream: false,
        prompt: user_message.message.content
      }.to_json

      headers = {
        content_type: :json,
        accept: :json
      }

      @response = RestClient.post(url, payload, headers)
      @body = JSON.parse(@response.body)
    end

    def message
      @body['response']
    end
  end
end

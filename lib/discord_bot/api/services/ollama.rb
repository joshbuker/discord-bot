module DiscordBot
  module Api
    module Services
      class Ollama < DiscordBot::Api::Service
        def default_api_url
          DiscordBot::GenAI::Text::API_URL
        end

        def list_local_models
          get('/api/tags')
        end

        def chat(messages:, model_name:)
          payload = {
            messages: messages,
            model:    model_name,
            stream:   false
          }.to_json
          post('/api/chat', payload)
        end

        def model_info(model_name:)
          payload = { name: model_name }.to_json
          post('/api/show', payload)
        end

        def pull_model(model_name:)
          payload = { name: model_name, stream: false }.to_json
          post('/api/pull', payload)
        end
      end
    end
  end
end

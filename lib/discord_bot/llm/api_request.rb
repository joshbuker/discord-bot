module DiscordBot
  module LLM
    ##
    # Provides access to the LLM via REST API Requests.
    #
    class ApiRequest
      DEFAULT_HEADERS = {
        content_type: :json,
        accept:       :json
      }.freeze

      class << self
        def get(endpoint, headers = DEFAULT_HEADERS, timeout = nil)
          RestClient::Request.execute(
            method:  :get,
            url:     "#{DiscordBot::LLM::API_URL}#{endpoint}",
            headers: headers,
            timeout: timeout
          )
        end

        def post(endpoint, payload, headers = DEFAULT_HEADERS, timeout = nil)
          RestClient::Request.execute(
            method:  :post,
            url:     "#{DiscordBot::LLM::API_URL}#{endpoint}",
            payload: payload,
            headers: headers,
            timeout: timeout
          )
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

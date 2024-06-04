module DiscordBot
  module StableDiffusion
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
            url:     "#{DiscordBot::StableDiffusion::API_URL}#{endpoint}",
            headers: headers,
            timeout: timeout
          )
        end

        def post(endpoint, payload, headers = DEFAULT_HEADERS, timeout = nil)
          RestClient::Request.execute(
            method:  :post,
            url:     "#{DiscordBot::StableDiffusion::API_URL}#{endpoint}",
            payload: payload,
            headers: headers,
            timeout: timeout
          )
        end

        def list_local_models
          get('/sdapi/v1/sd-models')
        end

        def text_to_image(prompt:, negative_prompt:, model_name: nil, cfg_scale:, steps:, width:, height:)
          raise ArgumentError, 'Must provide a prompt!' unless prompt.present?
          negative_prompt ||= ''

          payload = {
            prompt: prompt,
            negative_prompt: negative_prompt,
            cfg_scale: cfg_scale,
            steps: steps,
            width: width,
            height: height
          }.to_json
          post('/sdapi/v1/txt2img', payload)
        end
      end
    end
  end
end

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

        def text_to_image(image_options:)
          raise ArgumentError, 'Must provide a prompt!' unless image_options.prompt.present?

          payload = {
            prompt: image_options.prompt,
            negative_prompt: image_options.negative_prompt,
            cfg_scale: image_options.cfg_scale,
            steps: image_options.steps,
            width: image_options.width,
            height: image_options.height
          }.to_json
          post('/sdapi/v1/txt2img', payload)
        end

        def image_to_image(image_options:)
          raise ArgumentError, 'Must provide a prompt!' unless image_options.prompt.present?

          payload = {
            prompt: image_options.prompt,
            negative_prompt: image_options.negative_prompt,
            cfg_scale: image_options.cfg_scale,
            steps: image_options.steps,
            width: image_options.width,
            height: image_options.height,
            init_images: [image_options.base_image]
          }.to_json
          post('/sdapi/v1/img2img', payload)
        end
      end
    end
  end
end

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

        # rubocop:disable Metrics/MethodLength
        def text_to_image(image_options:)
          unless image_options.prompt.present?
            raise ArgumentError,
              'Must provide a prompt!'
          end

          payload = {
            prompt:            image_options.prompt,
            negative_prompt:   image_options.negative_prompt,
            cfg_scale:         image_options.cfg_scale,
            steps:             image_options.steps,
            width:             image_options.width,
            height:            image_options.height,
            override_settings: {
              nudenet_nsfw_censor_enable: false
            }
          }.to_json
          post('/sdapi/v1/txt2img', payload)
        end

        def image_to_image(image_options:)
          unless image_options.prompt.present?
            raise ArgumentError,
              'Must provide a prompt!'
          end

          payload = {
            prompt:          image_options.prompt,
            negative_prompt: image_options.negative_prompt,
            cfg_scale:       image_options.cfg_scale,
            steps:           image_options.steps,
            width:           image_options.width,
            height:          image_options.height,
            init_images:     [image_options.base_image]
          }.to_json
          post('/sdapi/v1/img2img', payload)
        end
        # rubocop:enable Metrics/MethodLength

        def nsfw_check(input_image:)
          unless input_image.present?
            raise ArgumentError,
              'Must provide an input image!'
          end

          payload = {
            input_image: input_image
          }.to_json
          post('/nudenet/censor', payload)
        end
      end
    end
  end
end

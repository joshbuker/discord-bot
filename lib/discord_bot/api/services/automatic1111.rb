module DiscordBot
  module Api
    module Services
      class Automatic1111 < DiscordBot::Api::Service
        def default_api_url
          DiscordBot::GenAI::Image::API_URL
        end

        def list_local_models
          get('/sdapi/v1/sd-models')
        end

        def text_to_image(image_options:)
          unless image_options.prompt.present?
            raise ArgumentError,
              'Must provide a prompt!'
          end

          # TODO: Refactor to image_options.to_payload
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

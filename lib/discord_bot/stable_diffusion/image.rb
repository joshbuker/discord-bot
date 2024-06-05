module DiscordBot
  module StableDiffusion
    class Image
      def initialize(image_options:)
        @options = image_options
        if image_options.base_image.present?
          response = DiscordBot::StableDiffusion::ApiRequest.image_to_image(
            image_options: image_options
          )
        else
          response = DiscordBot::StableDiffusion::ApiRequest.text_to_image(
            image_options: image_options
          )
        end
        @body = JSON.parse(response.body)
      end

      attr_reader :body, :options

      def about
          "**Prompt:**\n```\n#{options.prompt}\n```\n" \
          "**Negative Prompt:**#{negative_prompt_details}\n" \
          "**CFG Scale:** `#{options.cfg_scale}` | " \
          "**Steps:** `#{options.steps}` | " \
          "**Size:** `#{options.width}x#{options.height}`"
      end

      def content
        # "data:image/jpg;base64,#{@body['images'].first}"
        base64_content = @body['images'].first
        if base64_content.present?
          StringIO.new(Base64.decode64(base64_content))
        else
          nil
        end
      end

      private

      def negative_prompt_details
        if options.negative_prompt.present?
          "\n```\n#{options.negative_prompt}\n```"
        else
          ' _N/A_'
        end
      end
    end
  end
end

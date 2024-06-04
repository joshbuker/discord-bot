module DiscordBot
  module StableDiffusion
    class Image
      def initialize(prompt:, negative_prompt: nil)
        @prompt = prompt
        @negative_prompt = negative_prompt.present? ? negative_prompt : ''
        @width = '256'
        @height = '256'
        @cfg_scale = '7'
        @steps = '20'
        response = DiscordBot::StableDiffusion::ApiRequest.text_to_image(
          prompt: @prompt,
          negative_prompt: @negative_prompt,
          width: @width,
          height: @height,
          cfg_scale: @cfg_scale,
          steps: @steps
        )
        @body = JSON.parse(response.body)
      end

      attr_reader :body, :prompt, :negative_prompt, :width, :height, :cfg_scale, :steps

      def about
        <<~ABOUT
          **Prompt:**
          ```
          #{prompt}
          ```
          **Negative Prompt:**#{negative_prompt_details}
          **CFG Scale:** `#{cfg_scale}` | **Steps:** `#{steps}` | **Size:** `#{width}x#{height}`
        ABOUT
      end

      def content
        # "data:image/jpg;base64,#{@body['images'].first}"
        @body['images'].first
      end

      private

      def negative_prompt_details
        if negative_prompt.present?
          "\n```\n#{negative_prompt}\n```"
        else
          ' _N/A_'
        end
      end
    end
  end
end

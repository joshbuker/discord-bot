module DiscordBot
  module GenAI
    module Image
      ##
      # Container for the various options associated with an image generation.
      #
      class Options
        DEFAULT_WIDTH = 512
        DEFAULT_HEIGHT = 512
        DEFAULT_STEPS = 20
        DEFAULT_CFG_SCALE = 7

        attr_reader :prompt, :negative_prompt, :width, :height, :steps,
          :cfg_scale, :base_image, :force_spoiler, :upscale_ratio

        # rubocop:disable Metrics
        def initialize(options = {})
          @prompt = options[:prompt]
          @negative_prompt = options[:negative_prompt] || ''
          @width = options[:width] || DEFAULT_WIDTH
          @height = options[:height] || DEFAULT_HEIGHT
          @steps = options[:steps] || DEFAULT_STEPS
          @cfg_scale = options[:cfg_scale] || DEFAULT_CFG_SCALE
          @force_spoiler = options[:force_spoiler] || false
          @upscale_ratio = options[:upscale_ratio] || 1.0
          # FIXME: This currently returns the attachment ID, not an object we can
          #        extract the base64 image from. Broken until that's in place.
          @base_image = options[:base_image] || nil

          raise NotImplementedError if @base_image.present?

          raise ArgumentError, 'Must provide a prompt' if @prompt.empty?
        end
        # rubocop:enable Metrics

        def about
          "**Prompt:**\n```\n#{prompt}\n```\n" \
          "**Negative Prompt:**#{negative_prompt_details}\n" \
          "**CFG Scale:** `#{cfg_scale}` | " \
          "**Steps:** `#{steps}` | " \
          "**Size:** `#{width}x#{height}`"
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
end

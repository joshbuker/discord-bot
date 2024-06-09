module DiscordBot
  module StableDiffusion
    ##
    # Container for the various options associated with an image generation.
    #
    class ImageOptions
      DEFAULT_WIDTH = 512
      DEFAULT_HEIGHT = 512
      DEFAULT_STEPS = 20
      DEFAULT_CFG_SCALE = 7

      attr_reader :prompt, :negative_prompt, :width, :height, :steps,
        :cfg_scale, :base_image

      # rubocop:disable Metrics
      def initialize(options = {})
        @prompt = options['prompt']
        @negative_prompt = options['negative_prompt'] || ''
        @width = options['width'] || DEFAULT_WIDTH
        @height = options['height'] || DEFAULT_HEIGHT
        @steps = options['steps'] || DEFAULT_STEPS
        @cfg_scale = options['cfg_scale'] || DEFAULT_CFG_SCALE
        # FIXME: This currently returns the attachment ID, not an object we can
        #        extract the base64 image from. Broken until that's in place.
        @base_image = options['base_image'] || nil

        raise NotImplementedError if @base_image.present?

        raise ArgumentError, 'Must provide a prompt' if @prompt.empty?
      end
      # rubocop:enable Metrics
    end
  end
end

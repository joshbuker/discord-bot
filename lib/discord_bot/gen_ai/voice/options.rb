module DiscordBot
  module GenAI
    module Voice
      ##
      # Container for the various options associated with a voice generation.
      #
      class Options
        DEFAULT_SPEED = 1.0
        DEFAULT_LANGUAGE = 'EN'.freeze
        DEFAULT_SPEAKER_ID = 'EN-Default'.freeze
        LANGUAGE_CHOICES = {
          'English'  => 'EN',
          'Spanish'  => 'ES',
          'French'   => 'FR',
          'Chinese'  => 'ZH',
          'Japanese' => 'JP',
          'Korean'   => 'KR'
        }.freeze
        SPEAKER_ID_CHOICES = {
          'American English'   => 'EN-US',
          'British English'    => 'EN-BR',
          'Indian English'     => 'EN_INDIA',
          'Australian English' => 'EN-AU',
          'Default English'    => 'EN-Default'
        }.freeze

        attr_reader :prompt, :playback_speed, :language, :speaker_id

        def initialize(options = {})
          @prompt = options[:prompt]
          @playback_speed = options[:playback_speed]
          @language = options[:language]
          # When using non-English, force the only valid option (same as language)
          @speaker_id =
            if @language.present? && @language != 'EN'
              options[:language]
            else
              options[:speaker_id]
            end

          raise ArgumentError, 'Must provide a prompt' if @prompt.empty?
        end
      end
    end
  end
end

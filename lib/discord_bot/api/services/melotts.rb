module DiscordBot
  module Api
    module Services
      ##
      # Provides access to MeloTTS via REST API Requests.
      #
      class MeloTTS < DiscordBot::Api::Request
        def default_api_url
          DiscordBot::MeloTTS::API_URL
        end

        def default_headers
          { content_type: :json }
        end

        def text_to_voice(voice_options:)
          unless voice_options.prompt.present?
            raise ArgumentError,
              'Must provide a prompt!'
          end

          payload = {
            text: voice_options.prompt,
            speed: voice_options.playback_speed,
            language: voice_options.language,
            speaker_id: voice_options.speaker_id
          }.compact.to_json

          response = post('/convert/tts', payload)
        rescue StandardError => e
          byebug
        end
      end
    end
  end
end

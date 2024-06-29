module DiscordBot
  module MeloTTS
    ##
    # Provides access to MeloTTS via REST API Requests.
    #
    class ApiRequest
      DEFAULT_HEADERS = {
        content_type: :json
      }.freeze

      class << self
        def get(endpoint, headers = DEFAULT_HEADERS, timeout = nil)
          RestClient::Request.execute(
            method:  :get,
            url:     "#{DiscordBot::MeloTTS::API_URL}#{endpoint}",
            headers: headers,
            timeout: timeout
          )
        end

        def post(endpoint, payload, headers = DEFAULT_HEADERS, timeout = nil)
          RestClient::Request.execute(
            method:  :post,
            url:     "#{DiscordBot::MeloTTS::API_URL}#{endpoint}",
            payload: payload,
            headers: headers,
            timeout: timeout
          )
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

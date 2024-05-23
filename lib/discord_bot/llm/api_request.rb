module DiscordBot
  module LLM
    class ApiRequest
      DEFAULT_HEADERS = {
        content_type: :json,
        accept: :json
      }

      def self.post(endpoint, payload, headers = DEFAULT_HEADERS, timeout = nil)
        RestClient::Request.execute(
          method: :post,
          url: "#{DiscordBot::LLM::API_URL}#{endpoint}",
          payload: payload,
          headers: headers,
          timeout: timeout
        )
      rescue StandardError => error
        raise error.message, DiscordBot::Errors::ApiRequestPostFailed
      end
    end
  end
end

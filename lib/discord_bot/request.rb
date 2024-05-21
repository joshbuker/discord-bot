module DiscordBot
  class Request
    MODEL_URL = "http://#{DiscordBot::API_HOST}:11434"

    def self.post(endpoint, payload, headers, timeout = nil)
      RestClient::Request.execute(
        method: :post,
        url: "#{MODEL_URL}#{endpoint}",
        payload: payload,
        headers: headers,
        timeout: timeout
      )
    end
  end
end

module DiscordBot
  module Api
    class Service
      attr_reader :api_url

      def initialize(**options)
        @api_url = options[:api_url] || default_api_url
      end

      def get(endpoint, headers = default_headers, timeout = nil)
        RestClient::Request.execute(
          method:  :get,
          url:     "#{api_url}#{endpoint}",
          headers: headers,
          timeout: timeout
        )
      end

      def post(endpoint, payload, headers = default_headers, timeout = nil)
        RestClient::Request.execute(
          method:  :post,
          url:     "#{api_url}#{endpoint}",
          payload: payload,
          headers: headers,
          timeout: timeout
        )
      end

      def default_headers
        { content_type: :json, accept: :json }
      end

      def default_api_url
        raise NotImplementedError
      end
    end
  end
end

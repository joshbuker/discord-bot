module DiscordBot
  module LLM
    class Model
      attr_reader :name

      # TODO: Add automatic retry with backoff
      def self.pull(model_name:)
        endpoint = '/api/pull'
        payload = { name: model_name, stream: false }.to_json
        DiscordBot::LLM::ApiRequest.post(endpoint, payload)
      rescue DiscordBot::Error => error
        raise "Model pull failed due to: \"#{error.message}\"",
          DiscordBot::Errors::FailedToPullModel
      end

      def initialize
        @name = DiscordBot::LLM::DEFAULT_MODEL
      end

      # TODO: Use ollama status check to see if model is ready for use
      def available?
        false
      end
    end
  end
end

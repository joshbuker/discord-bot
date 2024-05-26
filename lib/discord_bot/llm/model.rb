module DiscordBot
  module LLM
    class Model
      attr_reader :name

      def self.available_models
        response = DiscordBot::LLM::ApiRequest.list_local_models
        models = JSON.parse(response.body)['models']
        models.map do |model|
          DiscordBot::LLM::Model.new(model_name: model['name'])
        end
      end

      def initialize(model_name: nil)
        if model_name.nil?
          @name = DiscordBot::LLM::DEFAULT_MODEL
        else
          @name = model_name
        end
      end

      # TODO: Use ollama status check to see if model is ready for use
      def available?
        model_info = DiscordBot::LLM::ApiRequest.model_info(model_name: name)
        true
      rescue RestClient::NotFound
        false
      end

      # TODO: Add automatic retry with backoff
      def pull
        return if available?
        DiscordBot::LLM::ApiRequest.pull_model(model_name: name)
      rescue RestClient::InternalServerError => error
        raise DiscordBot::Errors::FailedToPullModel,
          "Model pull failed due to: \"#{error.message}\""
      end
    end
  end
end

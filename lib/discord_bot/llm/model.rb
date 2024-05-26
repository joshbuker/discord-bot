module DiscordBot
  module LLM
    class Model
      attr_reader :name, :file_size, :parameter_size, :quantization_level

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

        details = model_details(model_name)
        @file_size = details['file_size']
        @parameter_size = details['parameter_size']
        @quantization_level = details['quantization_level']
      end

      def available?
        DiscordBot::LLM::ApiRequest.model_info(model_name: name)
        true
      rescue RestClient::NotFound
        false
      end

      def about
        "Name: `#{name}` - File size: `#{file_size}` - Parameter size: `#{parameter_size}` - Quantization level: `#{quantization_level}`"
      end

      # TODO: Add automatic retry with backoff
      def pull
        return if available?
        DiscordBot::LLM::ApiRequest.pull_model(model_name: name)
      rescue RestClient::InternalServerError => error
        raise DiscordBot::Errors::FailedToPullModel,
          "Model pull failed due to: \"#{error.message}\""
      end

      private

      def model_identifier
        if name.include?(':')
          name
        else
          "#{name}:latest"
        end
      end

      def model_details(model_name)
        response = DiscordBot::LLM::ApiRequest.list_local_models
        model_info = JSON.parse(response.body)['models'].find{ |model| model['name'] == model_identifier }
        if model_info.present?
          model_info['details'].merge({ 'file_size' => model_info['size'].to_human_filesize })
        else
          {}
        end
      rescue RestClient::NotFound
        {}
      end
    end
  end
end

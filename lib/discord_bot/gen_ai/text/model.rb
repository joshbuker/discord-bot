module DiscordBot
  module GenAI
    module Text
      ##
      # Represents an Ollama model
      #
      class Model
        attr_reader :name, :file_size, :parameter_size, :quantization_level,
          :bot, :api

        def self.available_models(bot)
          response = bot.api.ollama.list_local_models
          models = JSON.parse(response.body)['models']
          models.map do |model|
            new(model_name: model['name'], bot: bot)
          end
        end

        def self.pull_default_model(bot)
          new(
            model_name: DiscordBot::GenAI::Text::DEFAULT_MODEL,
            bot:        bot
          ).pull
        rescue DiscordBot::Errors::FailedToPullModel => e
          bot.logger.error e.message
        end

        def initialize(bot:, model_name: nil)
          @name = if model_name.nil?
                    DiscordBot::GenAI::Text::DEFAULT_MODEL
                  else
                    model_name
                  end

          @bot = bot
          @api = bot.api
          details = model_details
          @file_size = details['file_size']
          @parameter_size = details['parameter_size']
          @quantization_level = details['quantization_level']
        end

        def available?
          api.ollama.model_info(model_name: name)
          true
        rescue RestClient::NotFound
          false
        end

        def about
          "Name: `#{name}` - " \
          "File size: `#{file_size}` - " \
          "Parameter size: `#{parameter_size}` - " \
          "Quantization level: `#{quantization_level}`"
        end

        # TODO: Add automatic retry with backoff
        def pull
          return if available?

          api.ollama.pull_model(model_name: name)
        rescue RestClient::InternalServerError => e
          raise DiscordBot::Errors::FailedToPullModel,
            "Model pull failed due to: \"#{e.message}\""
        end

        private

        def model_identifier
          if name.include?(':')
            name
          else
            "#{name}:latest"
          end
        end

        def model_details
          response = api.ollama.list_local_models
          model_info = JSON.parse(response.body)['models'].find do |model|
            model['name'] == model_identifier
          end
          if model_info.present?
            model_info['details'].merge(
              { 'file_size' => model_info['size'].to_human_filesize }
            )
          else
            {}
          end
        rescue RestClient::NotFound
          {}
        end
      end
    end
  end
end

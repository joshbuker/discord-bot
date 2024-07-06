module DiscordBot
  module Initializers
    class PullDefaultModels < DiscordBot::Initializer
      # TODO: Ducktype this?
      # include Setupable

      def run?
        !bot.config.fast_boot
      end

      def setup
        logger.info 'Pulling default models'
        DiscordBot::GenAI::Text::Model.pull_default_model(bot)
      end
    end
  end
end

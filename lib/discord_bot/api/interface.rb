module DiscordBot
  module Api
    class Interface
      attr_reader :bot, :automatic1111, :melotts, :ollama

      def initialize(bot)
        @bot = bot
        @automatic1111 = DiscordBot::Api::Services::Automatic1111.new(
          api_url: bot.config.automatic1111_api_url
        )
        @melotts = DiscordBot::Api::Services::MeloTTS.new(
          api_url: bot.config.melotts_api_url
        )
        @ollama = DiscordBot::Api::Services::Ollama.new(
          api_url: bot.config.ollama_api_url
        )
      end
    end
  end
end

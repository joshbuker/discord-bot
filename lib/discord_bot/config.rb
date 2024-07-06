module DiscordBot
  ##
  # Allows overwriting various settings for the Bot
  #
  class Config
    LOG_LEVELS = {
      debug: 0,
      info: 1,
      warn: 2,
      error: 3,
      fatal: 4
    }
    DEFAULT_LOG_LEVEL = :info
    DEFAULT_ADMIN_USER_IDS = [
      121_475_289_397_198_848,
      227_141_869_962_919_936,
      381_899_834_564_804_622,
      478_093_835_172_446_209,
      722_652_181_894_791_238
    ]
    DEFAULT_SLASH_COMMAND_SERVER_IDS = [
      933_463_011_551_764_550,
      1_237_136_024_573_051_053
    ]
    DEFAULT_LOG_FILE_PATH = '/var/log/ruby_discord_bot.log'

    attr_reader :admin_user_ids, :bot_name, :discord_bot_token, :log_file_path,
      :slash_command_server_ids, :fast_boot, :skip_motd, :options,
      :automatic1111_api_url, :melotts_api_url, :ollama_api_url

    # rubocop:disable Layout/LineLength
    def initialize(**options)
      @options = options
      # TODO: Migrate admin users to Slash command permissions?
      @admin_user_ids = settings(:admin_user_ids, DEFAULT_ADMIN_USER_IDS)
      @bot_name = settings(:bot_name, 'Ruby')
      @discord_bot_token = settings(:discord_bot_token)
      @slash_command_server_ids = settings(:slash_command_server_ids, DEFAULT_SLASH_COMMAND_SERVER_IDS)
      @fast_boot = settings(:fast_boot, false)
      @skip_motd = settings(:skip_motd, false)
      @log_file_path = settings(:log_file_path, DEFAULT_LOG_FILE_PATH)
      @automatic1111_api_url = settings(:automatic1111_api_url, DiscordBot::GenAI::Image::API_URL)
      @melotts_api_url = settings(:melotts_api_url, DiscordBot::GenAI::Voice::API_URL)
      @automatic1111_api_url = settings(:ollama_api_url, DiscordBot::GenAI::Text::API_URL)
    end
    # rubocop:enable Layout/LineLength

    # TODO: Determine least privilege and request that instead
    def discord_bot_intents
      if !options[:discord_bot_intents].nil?
        options[:discord_bot_intents]
      else
        fetch_intents_from_env(:all)
      end
    end

    # Some way to log this on bootup? Probably should make Config an instance
    def log_level
      @level ||= options[:log_level] || ENV['LOG_LEVEL']&.downcase&.to_sym || DEFAULT_LOG_LEVEL
      return @level if LOG_LEVELS.key?(@level)
      raise DiscordBot::Errors::InvalidConfig,
        "Invalid log level provided: #{@level}"
    end

    def log_level?(level)
      LOG_LEVELS[log_level] <= LOG_LEVELS[level]
    end

    private

    def fetch_intents_from_env(default)
      intents =
        ENV['DISCORD_BOT_INTENTS'].to_s.delete(' []:').split(',').map(&:to_sym)
      return intents if intents.present?
      default
    end

    def settings(key, default = nil)
      if !options[key].nil?
        options[key]
      else
        ENV.fetch(key.to_s.underscore.upcase, default)
      end
    end
  end
end

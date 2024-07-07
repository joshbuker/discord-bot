module DiscordBot
  ##
  # Logs various usage information.
  #
  # TODO: See if more metadata should be attached for monitoring purposes
  # REVIEW: Should this be replaced with Ruby's built-in logger?
  #         Or semantic_logger: https://logger.rocketjob.io/
  #                             https://github.com/reidmorrison/semantic_logger
  #
  class Logger
    attr_reader :config

    def initialize(bot)
      @config = bot.config
    end

    def log(message, level: :unknown)
      timestamp = DateTime.now.iso8601
      write_stdout(stdout_format(timestamp, message, level))
      # write_logfile(logfile_format(timestamp, message, level))
    end

    # def trace(message)
    #   return unless config.log_level?(:trace)
    #   log(message, level: :trace)
    # end

    def debug(message)
      return unless config.log_level?(:debug)

      log(message, level: :debug)
    end

    def info(message)
      return unless config.log_level?(:info)

      log(message, level: :info)
    end

    # REVIEW: warn or warning? Which should be used?
    def warn(message)
      return unless config.log_level?(:warn)

      log(message, level: :warn)
    end

    def error(message)
      return unless config.log_level?(:error)

      log(message, level: :error)
    end

    def fatal(message)
      return unless config.log_level?(:fatal)

      log(message, level: :fatal)
    end

    private

    def write_stdout(content)
      puts content
    end

    def write_logfile(content)
      File.write(
        config.log_file,
        content,
        mode: 'a+'
      )
    end

    def stdout_format(timestamp, message, level)
      "#{timestamp} - #{level.to_s.upcase}: #{message}"
    end

    def logfile_format(timestamp, message, level)
      {
        timestamp: timestamp,
        level:     level,
        message:   message
      }.to_json
    end
  end
end

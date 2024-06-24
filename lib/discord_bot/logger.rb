module DiscordBot
  ##
  # Logs various usage information.
  #
  # TODO: See if more metadata should be attached for monitoring purposes
  # TODO: Should this be replaced with Ruby's built-in logger?
  #
  class Logger
    def self.log(message)
      puts message
    end

    def self.debug(message)
      return unless Config.log_level?(:debug)
      log("DEBUG: #{message}")
    end

    def self.info(message)
      return unless Config.log_level?(:info)
      log("INFO: #{message}")
    end

    def self.warn(message)
      return unless Config.log_level?(:warn)
      log("WARNING: #{message}")
    end

    def self.error(message)
      return unless Config.log_level?(:error)
      log("ERROR: #{message}")
    end

    def self.fatal(message)
      return unless Config.log_level?(:fatal)
      log("FATAL: #{message}")
    end
  end
end

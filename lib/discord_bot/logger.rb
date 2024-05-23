module DiscordBot
  class Logger
    def self.log(message)
      puts message
    end

    def self.info(message)
      log("INFO: #{message}")
    end

    def self.warn(message)
      log("WARNING: #{message}")
    end

    def self.error(message)
      log("ERROR: #{message}")
    end

    def self.fatal(message)
      log("FATAL: #{message}")
    end
  end
end

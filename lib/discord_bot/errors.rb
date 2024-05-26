module DiscordBot
  ##
  # Custom error class for rescuing from all DiscordBot errors.
  #
  class Error < StandardError; end

  module Errors
    class NotImplementedError < DiscordBot::Error; end
    class ApiRequestPostFailed < DiscordBot::Error; end
    class FailedToPullModel < DiscordBot::Error; end
    class PermissionDenied < DiscordBot::Error; end
  end
end

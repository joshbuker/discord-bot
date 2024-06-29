module DiscordBot
  ##
  # Wrapper around the User object
  #
  class User
    def initialize(user)
      raise ArgumentError, 'Invalid user' unless user.present?

      @user = user
    end

    def self.find_user_by_id(bot:, id:)
      new(bot.discord_bot.user(id))
    end

    def whois
      "@#{@user.name}"
    end

    attr_reader :user

    def mention
      @user.mention
    end

    def name
      if @user.nickname.present?
        @user.nickname
      elsif @user.global_name.present?
        @user.global_name
      else
        @user.name
      end
    end

    def id
      @user.id
    end

    def direct_message(message)
      @user.pm(message)
    end

    def ==(other)
      return false if other.nil?

      if can_compare?(other)
        id == other.id
      else
        raise ArgumentError,
          "Cannot compare #{self.class.name} to #{other.class.name}, both " \
          'must be users'
      end
    end

    private

    def can_compare?(other)
      other.is_a?(DiscordBot::User) ||
      other.is_a?(Discordrb::User) ||
      other.is_a?(Discordrb::Member)
    end
  end
end

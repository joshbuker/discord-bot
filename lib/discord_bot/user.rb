module DiscordBot
  class User
    def initialize(id: nil, user: nil)
      if user
        @user = user
      elsif id
        @user = Bot.find_user_by_id(id)
      end

      if @user.nil?
        raise ArgumentError, 'Invalid user'
      end
    end

    def id
      @user.id
    end

    def ==(other)
      return false if other.nil?
      if can_compare?(other)
        id == other.id
      else
        raise ArgumentError,
          "Cannot compare #{self.class.name} to #{other.class.name}, both must be users"
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

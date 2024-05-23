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
      if other.is_a?(DiscordBot::User)
        id == other.id
      elsif other.is_a?(Discordrb::User)
        # self == new(other.id)
        id == other.id
      else
        raise ArgumentError, 'Can only compare Discord users'
      end
    end
  end
end

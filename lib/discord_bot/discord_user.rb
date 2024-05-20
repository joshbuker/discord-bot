module DiscordBot
  class DiscordUser
    def initialize(server:,user_id:)
      return if server.nil?

      @user = server.members.detect{ |member| member.id == user_id }
    end

    def mention
      @user.mention
    end

    def display_name
      if @user.nickname
        @user.nickname
      elsif @user.global_name
        @user.global_name
      else
        @user.name
      end
    end
  end
end

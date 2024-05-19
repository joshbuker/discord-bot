module DiscordBot
  class MessageResponder
    def initialize(bot:)
      @bot = bot
    end

    def handle
      @bot.message do |event|
        user_message = UserMessage.new(event)
        Logger.log("Message received: #{user_message.message.content}")

        if user_message.message.content.include?('(╯°□°)╯︵ ┻━┻')
          fix_table(user_message)
        elsif user_message.message.mentions.include?(@bot.user)
          reply_to_message(user_message)
        else
          no_action(user_message)
        end
      end
    end

    private

    def fix_table(user_message)
      user_message.reply_with("┬─┬ノ( º _ ºノ)\nSo uncivilized!")
    end

    def reply_to_message(user_message)
      user_message.reply_with('uwu')
    end

    def no_action(user_message)
      Logger.log 'No action needed'
    end
  end
end

module DiscordBot
  class MessageResponder
    def initialize(bot:)
      @bot = bot
      @channel_conversation_histories = {}
    end

    def handle
      @bot.message do |event|
        user_message = UserMessage.new(event)
        Logger.log("Message received: #{user_message.message.content}")

        if user_message.message.content.include?('(╯°□°)╯︵ ┻━┻')
          fix_table(user_message)
        elsif user_message.message.mentions.include?(@bot.user) || user_message.server.nil?
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

    def channel_conversation_history(channel_id:)
      if @channel_conversation_histories[channel_id].nil?
        @channel_conversation_histories[channel_id] = ConversationHistory.new
      end

      @channel_conversation_histories[channel_id]
    end

    def reply_to_message(user_message)
      conversation_history = channel_conversation_history(channel_id: user_message.channel.id)

      typing_thread = Thread.new do
        while(true)
          user_message.channel.start_typing
          sleep(3) # Wait for 3 seconds before triggering again
        end
      end
      response = ModelResponse.new(
        conversation_history: conversation_history,
        user_message: user_message
      )
      typing_thread.exit

      Logger.log("Reply sent: #{response.message}")
      if response.message
        user_message.reply_with(response.message)
      else
        byebug
      end
    end

    def no_action(user_message)
      Logger.log 'No action needed'
    end
  end
end

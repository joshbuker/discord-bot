module DiscordBot
  class MessageHandler
    attr_reader :bot, :logger

    def initialize(bot)
      @bot = bot
      @logger = bot.logger
    end

    def handle
      bot.discord_bot.message do |event|
        handle_message(DiscordBot::Events::Message.new(event))
      end
    end

    private

    # TODO: Refactor this into a factory
    def handle_message(message)
      logger.info "Message received (#{message.from}):\n#{message.content}"
      if message.content.start_with?('!prompt ')
        set_system_prompt_from_chat(message)
      elsif message.content.include?('(╯°□°)╯︵ ┻━┻')
        fix_table(message)
      elsif message.addressed_to_bot?
        reply_to_message(message)
      else
        no_action(message)
      end
    end

    # rubocop:disable Naming/AccessorMethodName
    # TODO: Remove, you can run global commands from DMs making this obsolete
    def set_system_prompt_from_chat(message)
      system_prompt = message.content.sub('!prompt ', '')
      logger.info(
        "System prompt for channel #{message.channel_id} has been reset to:" \
        "\n#{system_prompt}"
      )
      bot.conversation(message.channel_id).system_prompt = system_prompt
      message.reply_with("System prompt has been reset to:\n\n#{system_prompt}")
    end
    # rubocop:enable Naming/AccessorMethodName

    def fix_table(message)
      message.reply_with("┬─┬ノ( º _ ºノ)\nSo uncivilized!")
    end

    def reply_to_message(message)
      typing_thread = message.start_typing_thread
      begin
        response = bot.conversation(message.channel_id).generate_response(message)
      ensure
        typing_thread.exit
      end
      logger.info "Reply sent (#{response.model.name}):\n#{response.message}"
      message.reply_with(response.message)
    end

    def no_action(_message)
      logger.info 'No action needed'
    end
  end
end

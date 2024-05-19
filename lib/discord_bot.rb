# frozen_string_literal: true

# This simple bot responds to every "Ping!" message with a "Pong!"

require 'discordrb'
require 'byebug'
require 'opus-ruby'

module DiscordBot
  class Bot
    def initialize(discord_bot_token)
      @bot = Discordrb::Bot.new(
        token: discord_bot_token
        # intents: [:server_messages]
      )

      initialize_callbacks
    end

    def run(skip_motd: false)
      Logger.log "Bot Invite URL: #{@bot.invite_url}" unless skip_motd
      Logger.log 'Initializing bot, please wait...'
      at_exit { @bot.stop }
      @bot.run(true)
      Logger.log 'Bot running...'
      @bot.join
    end

    private

    def user
      @bot.bot_user
    end

    def initialize_callbacks
      @bot.message do |event|
        Logger.log("Message received: #{event.message.content}")
        if event.message.content == '!tuturu'
          play_tuturu(event)
        elsif event.message.mentions.include?(user)
          reply_to_message(event)
        else
          no_action(event)
        end
      end
    end

    def reply_to_message(event)
      event.message.reply! 'uwu'
    end

    def connect_to_channel(event)
      channel = event.user.voice_channel

      unless channel
        event.respond "You're not in any voice channel!"
        return
      end

      @bot.voice_connect(channel)
      Logger.log "Connected to voice channel: #{channel.name}"
    end

    def play_tuturu(event)
      connect_to_channel(event)

      voip = event.voice
      if voip
        Logger.log 'Playing tuturu.wav'
        voip.play_file('data/tuturu.wav')
        event.respond 'Tuturu!'
        Logger.log "Disconnecting from voice channel: #{voip.channel.name}"
        voip.destroy
      else
        event.respond "I'm sorry, something went wrong. :("
      end
    end

    def no_action(event)
      Logger.log 'No action needed'
    end
  end

  class Logger
    def self.log(message)
      puts message
    end
  end
end

discord_bot = DiscordBot::Bot.new(ENV['RUBY_DISCORD_BOT_TOKEN'])
discord_bot.run

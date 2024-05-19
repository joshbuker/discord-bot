# frozen_string_literal: true

# This simple bot responds to every "Ping!" message with a "Pong!"

require 'discordrb'
require 'byebug'
require 'opus-ruby'

module DiscordBot
  class Bot
    def initialize(discord_bot_token:,refresh_commands: true)
      Logger.log 'Initializing bot, please wait...'
      @bot = Discordrb::Bot.new(
        token: discord_bot_token,
        intents: :all
        # intents: [:server_messages]
      )

      Logger.log 'Registering commands...'
      register_commands if refresh_commands
      # TODO: Remove unused commands
      Logger.log 'Initializing callbacks...'
      initialize_callbacks
    end

    def run(skip_motd: false)
      Logger.log "Bot Invite URL: #{@bot.invite_url}" unless skip_motd
      at_exit { @bot.stop }
      Logger.log 'Starting bot...'
      @bot.run(true)
      Logger.log 'Bot running...'
      @bot.join
    end

    private

    def user
      @bot.bot_user
    end

    def send_message(event:, message:)
      @bot.send_message(event.channel.id, message)
    end

    def register_commands
      # Register server specific commands (instant)
      slash_command_server_ids.each do |server_id|
        @bot.register_application_command(:help, 'Provides a full list of commands in chat', server_id: server_id)
        @bot.register_application_command(:tuturu, 'Play a fun sound in your current voice channel', server_id: server_id)
        @bot.register_application_command(:exit, 'Shutdown the bot', server_id: server_id)
        @bot.register_application_command(:source, 'Provide the sauce', server_id: server_id)
      end
      # Register global commands (delayed)
      # @bot.register_application_command(:exit, '')
    end

    def initialize_callbacks
      @bot.message do |event|
        Logger.log("Message received: #{event.message.content}")
        if event.message.content.include?('(╯°□°)╯︵ ┻━┻')
          fix_table(event)
        elsif event.message.mentions.include?(user)
          reply_to_message(event)
        else
          no_action(event)
        end
      end

      @bot.application_command(:exit) do |event|
        shutdown_bot(event)
      end

      @bot.application_command(:help) do |event|
        event.respond(content: help_message)
      end

      @bot.application_command(:tuturu) do |event|
        play_tuturu(event)
      end

      @bot.application_command(:source) do |event|
        send_source_code(event)
      end
    end

    def authorized_users
      [
        121475289397198848
      ]
    end

    def slash_command_server_ids
      [
        933463011551764550,
        1237136024573051053
      ]
    end

    def shutdown_bot(event)
      return unless authorized_users.include?(event.user.id)

      event.respond(content: 'Shutting down, see you next time!')
      Logger.log('Exiting by admin request')
      exit
    end

    def help_message
      <<~help
        ```
        /help or /h - Show this help message
        /tuturu     - Play a fun sound in your current voice channel
        /source     - Get the source code for this bot
        ```
      help
    end

    def send_source_code(event)
      event.respond(content: "You can find my source code at: https://github.com/joshbuker/discord-bot")
    end

    def reply_to_message(event)
      event.message.reply! 'uwu'
    end

    def fix_table(event)
      event.message.reply! "┬─┬ノ( º _ ºノ)\nSo uncivilized!"
    end

    def connect_to_channel(event)
      channel = event.user.voice_channel

      unless channel
        event.edit_response(content: "You're not in any voice channel!\nPlease join a voice channel then run `/tuturu` again.")
        return
      end

      @bot.voice_connect(channel)
      Logger.log "Connected to voice channel: #{channel.name}"
      event.edit_response(content: 'Channel joined, playing sound momentarily...')
      return channel
    end

    def play_tuturu(event)
      event.respond(content: 'Attempting to join channel...')
      channel = connect_to_channel(event)

      voip = @bot.voice(channel.id)
      if voip
        Logger.log 'Playing tuturu.wav'
        voip.play_file('data/tuturu.wav')
        Logger.log "Disconnecting from voice channel: #{channel.name}"
        voip.destroy
        event.edit_response(content: 'Tuturu!')
        return
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

discord_bot = DiscordBot::Bot.new(
  discord_bot_token: ENV['RUBY_DISCORD_BOT_TOKEN']
)
discord_bot.run

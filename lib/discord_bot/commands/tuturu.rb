module DiscordBot
  module Commands
    class Tuturu < Base
      def name
        :tuturu
      end

      def description
        'Play a fun sound in your current voice channel'
      end

      def run(command_run)
        command_run.respond_with('Attempting to join channel...')
        channel = connect_to_channel(command_run)

        voip = @bot.voice(channel.id)
        if voip
          Logger.log 'Playing tuturu.wav'
          voip.play_file('/workspaces/discord-bot/data/tuturu.wav')
          Logger.log "Disconnecting from voice channel: #{channel.name}"
          voip.destroy
          command_run.update_response('Tuturu!')
        end
      end

      private

      def connect_to_channel(command_run)
        channel = command_run.user.voice_channel

        unless channel
          command_run.update_response("You're not in any voice channel!\nPlease join a voice channel then run `/tuturu` again.")
          return
        end

        @bot.voice_connect(channel)
        Logger.log "Connected to voice channel: #{channel.name}"
        command_run.update_response('Channel joined, playing sound momentarily...')
        return channel
      end
    end
  end
end

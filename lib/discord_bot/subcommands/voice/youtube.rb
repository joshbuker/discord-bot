module DiscordBot
  module Subcommands
    module Voice
      class Youtube < DiscordBot::Subcommand
        def description
          'Play audio from a YouTube video'
        end

        def register_options(options)
          options.string(:url, 'URL of the youtube video', required: true)
        end

        def run(command_event)
          voice_channel = command.bot_voice_channel
          url = command.options['url']
          if connected_to_voice?(voice_channel)
            voip = Bot.voice(voice_channel.id)
            if valid_youtube_url?(url)
              logger.info "Playing YouTube video: #{url}"
              command.respond_with('Playing YouTube video...')
              voip.play_io(youtube_video_io(url))
              command.update_response('Finished playing')
            else
              logger.warn 'Invalid YouTube URL'
              command.respond_with('Invalid YouTube URL')
            end
          else
            command.respond_with(
              'Please connect to voice with `/voice connect` first'
            )
          end
        end

        private

        # Yo dawg, I heard you like vulnerabilities
        def youtube_video_io(url)
          sanitized_url = Shellwords.escape(url)
          IO.popen("youtube-dl -q -o - #{sanitized_url}")
        end

        def valid_youtube_url?(url)
          uri = URI(url)
          ['youtu.be', 'youtube.com', 'www.youtube.com'].include?(uri.host)
        rescue StandardError
          false
        end
      end
    end
  end
end

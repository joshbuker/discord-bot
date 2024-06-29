module DiscordBot
  module Subcommands
    module Voice
      class Generate < DiscordBot::Subcommand
        def description
          'Generate text to speech and send as file'
        end

        def register_options(options)
          options.string(:prompt, 'The text to be converted into speech', required: true)
          options.number(:playback_speed, 'How fast the speech should be (0.5 = half speed)')
          options.string(:language, 'What language to generate in', choices: LANGUAGE_CHOICES)
          options.string(:speaker_id, 'What accent to use, currently only supports English', choices: SPEAKER_ID_CHOICES)
        end

        def run(command_event)
          voice_options = DiscordBot::MeloTTS::VoiceOptions.new(
            command.options
          )
          command.respond_with('Generating voice')
          begin
            voice = DiscordBot::MeloTTS::Voice.new(
              voice_options: voice_options
            )
          rescue StandardError => e
            logger.error "Failed to generate voice due to:\n#{e.message}"
            command.update_response(
              "Failed to generate voice due to the following error:\n" \
              "#{e.message}"
            )
            return
          end
          caption = "Generated a voice recording requested by #{command.user.mention}"
          command.send_file(
            file: voice.file,
            filename: 'attachment.wav',
            caption: caption
          )
        end
      end
    end
  end
end

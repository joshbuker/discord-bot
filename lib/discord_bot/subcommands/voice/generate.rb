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
          options.string(:language, 'What language to generate in', choices: DiscordBot::GenAI::Voice::Options::LANGUAGE_CHOICES)
          options.string(:speaker_id, 'What accent to use, currently only supports English', choices: DiscordBot::GenAI::Voice::Options::SPEAKER_ID_CHOICES)
        end

        def run(command_event)
          voice_options = DiscordBot::GenAI::Voice::Options.new(
            command_event.options.symbolize_keys
          )
          command_event.respond_with('Generating voice')
          begin
            voice = DiscordBot::GenAI::Voice::Response.create(
              voice_options: voice_options,
              bot:           bot
            )
          rescue StandardError => e
            logger.error "Failed to generate voice due to:\n#{e.message}"
            command_event.update_response(
              "Failed to generate voice due to the following error:\n" \
              "#{e.message}"
            )
            return
          end
          caption = "Generated a voice recording requested by #{command_event.user.mention}"
          command_event.send_file(
            file:     voice.file,
            filename: 'attachment.wav',
            caption:  caption
          )
        end
      end
    end
  end
end

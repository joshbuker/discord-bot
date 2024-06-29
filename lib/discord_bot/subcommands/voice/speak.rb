module DiscordBot
  module Subcommands
    module Voice
      class Speak < DiscordBot::Subcommand
        def description
          'Generate text to speech and speak it on channel'
        end

        def register_options(options)
          options.string(:prompt, 'The text to be converted into speech', required: true)
          options.number(:playback_speed, 'How fast the speech should be (0.5 = half speed)')
          options.string(:language, 'What language to generate in', choices: LANGUAGE_CHOICES)
          options.string(:speaker_id, 'What accent to use, currently only supports English', choices: SPEAKER_ID_CHOICES)
        end

        def run(command_event)
          voice_channel = command.bot_voice_channel
          if connected_to_voice?(voice_channel)
            voip = Bot.voice(voice_channel.id)
            logger.info "Playing voice"
            command.respond_with('Generating voice')
            voice_options = DiscordBot::MeloTTS::VoiceOptions.new(
              command.options
            )
            voice = DiscordBot::MeloTTS::Voice.new(
              voice_options: voice_options
            )
            command.update_response('Playing voice...')
            # voip.play_file(voice.file)
            voice.tempfile do |file|
              voip.play_file(file.path)
            end
            command.update_response('Finished playing')
          else
            command.respond_with(
              'Please connect to voice with `/voice connect` first'
            )
          end
        end
      end
    end
  end
end

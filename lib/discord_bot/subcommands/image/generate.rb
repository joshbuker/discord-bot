module DiscordBot
  module Subcommands
    module Image
      class Generate < DiscordBot::Subcommand
        def description
          'Generate an image using Stable Diffusion'
        end

        def register_options(options)
          options.string(:prompt, 'The prompt for the image', required: true)
          options.string(:negative_prompt, 'The negative prompt for the image')
          options.integer(:steps, 'How many iterations to pass over the image (default: 20)')
          options.number(:cfg_scale, 'How closely to follow the prompt instructions (default: 7)')
          options.integer(:width, 'The width in pixels of the image (default: 512)')
          options.integer(:height, 'The height in pixels of the image (default: 512)')
          options.number(:upscale_ratio, 'How much to upscale from the original size')
          options.boolean(:force_spoiler, 'Force spoiler mode to be enabled (default: false)')
          options.attachment(:base_image, 'Base image to work from for image to image')
        end

        # FIXME: Clearly too complex
        # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        def run(command_event)
          image_options = DiscordBot::GenAI::Image::Options.new(
            command_event.options.symbolize_keys
          )
          logger.warn(
            "Image requested by #{command_event.whois} with the following " \
            "parameters:\n#{image_options.about}"
          )
          require_admin!(
            command_event,
            'This command is restricted to admins until some safeguards ' \
            'have been implemented.'
          ){ return }
          # HACK: This should be solved by using server commands instead of
          #       global commands, rather than checking if ran in a DM
          prevent_direct_messages!(command_event, image_options){ return }
          logger.info("Image requested by #{command_event.whois}")
          command_event.respond_with('Generating image')
          begin
            image = DiscordBot::GenAI::Image::Response.create(
              image_options: image_options
            )
          rescue StandardError => e
            logger.info "Failed to generate image due to:\n#{e.message}"
            command_event.update_response(
              "Failed to generate image due to the following error:\n" \
              "#{e.message}"
            )
            return
          end
          logger.info 'Sending image'
          caption =
            "Generated an image requested by #{command_event.user.mention}:\n" \
            "#{image.about}"
          command_event.send_file(
            file:     image.file,
            filename: 'attachment.png',
            caption:  caption,
            spoiler:  image.nsfw?
          )
          command_event.update_response('Image sent')
          logger.info(
            "Sent image with the following options:\n#{image.about}"
          )
        end
        # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

        private

        def prevent_direct_messages!(command_event)
          if command_event.direct_message?
            logger.info(
              "#{command_event.whois} tried running the image generate command " \
              "in a direct message with the following parameters:\n" \
              "#{image_options.about}"
            )
            command_event.respond_with(
              'This command is restricted to servers until some safeguards ' \
              'have been implemented.'
            )
            yield
          end
        end
      end
    end
  end
end

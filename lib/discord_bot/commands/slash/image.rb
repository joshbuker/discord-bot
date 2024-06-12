module DiscordBot
  module Commands
    module Slash
      ##
      # Command for generating images via Stable Diffusion.
      #
      class Image < Base
        class << self
          # rubocop:disable Metrics/MethodLength
          def register
            # Logger.info "Registering #{command_name} command"
            Bot.register_command(command_name, description) do |command|
              command.subcommand(:generate, 'Generate an image using Stable Diffusion') do |options|
                options.string(:prompt, 'The prompt for the image', required: true)
                options.string(:negative_prompt, 'The negative prompt for the image')
                options.integer(:steps, 'How many iterations to pass over the image (default: 20)')
                options.integer(:cfg_scale, 'How closely to follow the prompt instructions (default: 7)')
                options.integer(:width, 'The width in pixels of the image (default: 512)')
                options.integer(:height, 'The height in pixels of the image (default: 512)')
                options.boolean(:force_spoiler, 'Force spoiler mode to be enabled (default: false)')
                options.attachment(:base_image, 'Base image to work from for image to image')
              end
            end
          end
          # rubocop:enable Metrics/MethodLength

          def handle
            Bot.command_callback(command_name).subcommand(:generate) do |event|
              generate_image(DiscordBot::Events::Command.new(event))
            end
          end

          def description
            'Uses stable diffusion to interact with images'
          end

          # FIXME: Clearly too complex
          # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
          def generate_image(command)
            unless command.ran_by_admin?
              Logger.info(
                "#{command.whois} tried running the image generate command " \
                'without permission'
              )
              command.respond_with(
                'This command is restricted to admins until some safeguards ' \
                'have been implemented.'
              )
              return
            end
            Logger.info("Image requested by #{command.whois}")
            command.respond_with('Generating image')
            image_options = DiscordBot::StableDiffusion::ImageOptions.new(
              command.options
            )
            begin
              image = DiscordBot::StableDiffusion::Image.new(
                image_options: image_options
              )
            rescue StandardError => e
              Logger.info "Failed to generate image due to:\n#{e.message}"
              command.update_response(
                "Failed to generate image due to the following error:\n" \
                "#{e.message}"
              )
            end
            Logger.info 'Sending image'
            caption =
              "Generated an image requested by #{command.user.mention}:\n" \
              "#{image.about}"
            command.send_image(
              image: image.file,
              caption: caption,
              spoiler: image.nsfw?
            )
            command.update_response('Image sent')
            Logger.info(
              "Sent image with the following options:\n#{image.about}"
            )
          end
          # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
        end
      end
    end
  end
end

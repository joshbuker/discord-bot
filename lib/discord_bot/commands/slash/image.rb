module DiscordBot
  module Commands
    module Slash
      ##
      # Command for generating images via Stable Diffusion.
      #
      class Image < Base
        class << self
          def register
            # Logger.info "Registering #{command_name} command"
            Bot.register_command(command_name, description) do |command|
              command.subcommand(:generate, 'Generate an image using Stable Diffusion') do |options|
                options.string(:prompt, 'The prompt for the image', required: true)
                options.string(:negative_prompt, 'The negative prompt for the image')
                # options.attachment(:image, 'Base image to work from for image to image')
              end
            end
          end

          def handle
            Bot.command_callback(command_name).subcommand(:generate) do |event|
              generate_image(DiscordBot::Events::Command.new(event))
            end
          end

          def description
            'Uses stable diffusion to interact with images'
          end

          def generate_image(command)
            prompt = command.options['prompt']
            negative_prompt = command.options['negative_prompt']
            Logger.info 'Generating image'
            command.respond_with('Generating image')
            image = DiscordBot::StableDiffusion::Image.new(
              prompt: prompt,
              negative_prompt: negative_prompt
            )
            Logger.info 'Sending image'
            command.update_with_base64_image(image.content, image.about)
            Logger.info 'Sent'
          rescue StandardError => e
            byebug
          end
        end
      end
    end
  end
end

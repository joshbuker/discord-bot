module DiscordBot
  module Commands
    module User
      ##
      # Command to say hello to a user, mostly for testing user commands.
      #
      class HelloFriend < Base
        class << self
          def command_name
            'Say hello to this user'
          end

          # rubocop:disable Metrics/MethodLength
          def run(command_event)
            require_admin!(
              command_event,
              'To prevent unwanted spam, this command is restricted to admins'
            ){ return }

            user = command_event.target_user
            logger.info(
              "#{command_event.whois} used the \"Hello Friend\" command on " \
              "#{user.whois}"
            )
            user.direct_message(
              "Hello friend!\n\n#{command_event.user.mention} wanted us to " \
              'get in touch.'
            )
            command_event.respond_with(
              "Hello friend message sent to #{user.mention}"
            )
          end
          # rubocop:enable Metrics/MethodLength
        end
      end
    end
  end
end

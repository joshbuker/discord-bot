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
          def run(command)
            unless command.ran_by_admin?
              Logger.info(
                "#{command.whois} tried running the \"Hello Friend\" " \
                'user command without permission'
              )
              command.respond_with(
                'To prevent unwanted spam, this command is restricted to admins'
              )
              return
            end
            user = command.target_user
            Logger.info(
              "#{command.whois} used the \"Hello Friend\" command on " \
              "#{user.whois}"
            )
            command.respond_with("Hello friend message sent to #{user.mention}")
            user.direct_message(
              "Hello friend!\n\n#{command.user.mention} wanted us to get in " \
              'touch.'
            )
          end
          # rubocop:enable Metrics/MethodLength
        end
      end
    end
  end
end

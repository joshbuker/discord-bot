module DiscordBot
  module Commands
    module Slash
      class NiceMessage < Base
        class << self
          def description
            "allows user to send a nice message to another user though ruby bot #{Config.bot_name}"
          end

          def register
            Bot.register_command(command_name, description) do |command|
              command.user(:user, 'What user to message?', required: true)
              command.string(:message, 'what message to send', required: true)
            end
          end
          
          def run(command)
            user=DiscordBot::User.new(user: Bot.find_user_by_id(command.options["user"]))
            message=command.options["message"]
            conversation=DiscordBot::LLM::Conversation.new
            model=DiscordBot::LLM::Model.new
            command.respond_with('Sending your nice message...')
            response=DiscordBot::LLM::Response.new(
              conversation_history: conversation,
              user_message: message,
              model: model
            )
            command.update_response('Nice message sent')
            user.direct_message(response.message)
            Logger.info(
              "message sent: #{command.options["message"]}\nsender: #{(command.whois)}\nSent to: #{user.whois}"
            )
          end
        end
      end
    end
  end
end

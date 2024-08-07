module DiscordBot
  module GenAI
    module Text
      class ChatMessage
        VALID_ROLES = %w[user assistant system].freeze

        attr_reader :role, :content

        # FIXME: I'm not super happy with this guard clause
        def initialize(role:, content:)
          unless VALID_ROLES.include?(role)
            raise ArgumentError,
              "Invalid role of #{role}, valid options are: " \
              "#{VALID_ROLES.join(', ')}"
          end

          @role = role
          @content = content
        end

        def to_hash
          { role: role, content: content }
        end

        def to_json(*_args)
          to_hash.to_json
        end
      end
    end
  end
end

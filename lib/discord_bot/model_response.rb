module DiscordBot
  class ModelResponse
    MODEL_URL = 'http://llm:11434/api/chat'

    def initialize(conversation_history:, user_message:)
      @user_message = user_message

      conversation_history.introduce(
        mention: user_message.user.mention,
        name: user_message.display_name
      )

      user_message.message.mentions.each do |mentioned_user|
        next if user_message.server.nil? # If in DMs, skip

        user = DiscordUser.new(
          server: user_message.server,
          user_id: mentioned_user.id
        )
        conversation_history.introduce(
          mention: user.mention,
          name: user.display_name
        )
      end

      prompt = "Prompt from \"#{user_message.user.mention}\":\n\n#{user_message.message.content}"
      Logger.log("Prompt:\n#{prompt}")

      conversation_history.append(
        role: 'user',
        message: prompt
      )

      url = MODEL_URL

      payload = {
        model: 'llama3',
        stream: false,
        messages: conversation_history.messages
      }.to_json

      headers = {
        content_type: :json,
        accept: :json
      }

      @response = RestClient.post(url, payload, headers)
      @body = JSON.parse(@response.body)

      conversation_history.append(
        role: 'assistant',
        message: message
      )
    end

    def message
      @body['message']['content']
    end
  end
end

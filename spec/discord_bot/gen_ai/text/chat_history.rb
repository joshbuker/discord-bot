require 'spec_helper'

RSpec.describe DiscordBot::GenAI::Text::ChatHistory do
  subject(:chat_history) { described_class.new(system_prompt: system_prompt) }
  let(:system_prompt) { 'Some system prompt' }

  describe 'append' do
    it 'appends a message to the end of the chat history' do
      message =
        DiscordBot::GenAI::Text::ChatMessage.new(role: 'user', content: 'Test message')
      expect(chat_history.messages.last).not_to eq(message)
      chat_history.append(message)
      expect(chat_history.messages.last).to eq(message)
    end

    it 'rejects strings' do
      expect do
        chat_history.append('Some message')
      end.to raise_error(ArgumentError)
    end
  end

  describe 'messages' do
    it 'can be rendered as json' do
      expect(chat_history.messages.to_json).to eq(
        "[{\"role\":\"system\",\"content\":\"#{system_prompt}\"}]"
      )
    end
  end
end

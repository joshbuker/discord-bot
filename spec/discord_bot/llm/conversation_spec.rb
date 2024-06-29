require 'spec_helper'

RSpec.describe DiscordBot::LLM::Conversation do
  subject(:conversation) { described_class.new(system_prompt: system_prompt) }
  let(:system_prompt) { 'Some system prompt' }

  describe 'append' do
    it 'appends a message to the end of the conversation' do
      message =
        DiscordBot::LLM::ChatMessage.new(role: 'user', content: 'Test message')
      expect(conversation.messages.last).not_to eq(message)
      conversation.append(message)
      expect(conversation.messages.last).to eq(message)
    end

    it 'rejects strings' do
      expect{
        conversation.append('Some message')
      }.to raise_error(ArgumentError)
    end
  end

  describe 'messages' do
    it 'can be rendered as json' do
      expect(conversation.messages.to_json).to eq(
        "[{\"role\":\"system\",\"content\":\"#{system_prompt}\"}]"
      )
    end
  end
end

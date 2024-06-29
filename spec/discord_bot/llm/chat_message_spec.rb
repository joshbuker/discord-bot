require 'spec_helper'

RSpec.describe DiscordBot::LLM::ChatMessage do
  subject(:chat_message) { described_class.new(role: role, content: content) }
  let(:content) { 'Some message' }

  context 'when passed an invalid role' do
    let(:role) { 'unknown' }

    it 'raises an ArgumentError' do
      expect{ chat_message }.to raise_error(ArgumentError)
    end
  end

  context 'when passed user role' do
    let(:role) { 'user' }

    it 'does not raise any errors' do
      expect{ chat_message }.not_to raise_error
    end

    it 'can render the message as a hash' do
      expect(chat_message.to_hash).to eq({
        role: role,
        content: content
      })
    end

    it 'can render the message as json' do
      expect(chat_message.to_json).to eq(
        "{\"role\":\"#{role}\",\"content\":\"#{content}\"}"
      )
    end
  end
end

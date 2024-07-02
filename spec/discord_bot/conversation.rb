require 'spec_helper'

RSpec.describe DiscordBot::Conversation do
  subject(:conversation) { described_class.new(bot) }
  let(:bot) { DiscordBot::Bot.new(config: config) }
  # REVIEW: Silences the logs while running tests
  #         (is there a better way to do this?)
  let(:config) { DiscordBot::Config.new(log_level: :fatal) }

  describe 'generate_response' do
    # FIXME: Currently makes an actual request to Ollama, which is slow and will
    #        break in CI. Replace with mock.
    subject(:generate_response) { conversation.generate_response(message) }
    let(:message) { 'Some message' }

    it { should be_a DiscordBot::LLM::Response }
  end
end

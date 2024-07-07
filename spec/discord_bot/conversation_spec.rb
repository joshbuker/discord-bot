require 'spec_helper'

RSpec.describe DiscordBot::Conversation do
  subject(:conversation) { described_class.new(bot) }

  let(:bot) { DiscordBot::Bot.new(config: config, api: api_double) }
  # REVIEW: Silences the logs while running tests
  #         (is there a better way to do this?)
  let(:config) do
    DiscordBot::Config.new(log_level: :fatal, discord_bot_token: 'invalid')
  end

  describe 'generate_response' do
    subject(:generate_response) { conversation.generate_response(message) }

    let(:message) { 'Some message' }

    it { should be_a DiscordBot::GenAI::Text::Response }
  end
end

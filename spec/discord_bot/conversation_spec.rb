require 'spec_helper'

RSpec.describe DiscordBot::Conversation do
  subject(:conversation) { described_class.new(bot) }

  let(:bot) { DiscordBot::Bot.new(config: config, api: api_double) }
  let(:api_double) { instance_double(DiscordBot::Api::Interface) }
  # FIXME: This is really unwieldly and ugly
  let(:ollama_service_double) do
    instance_double(DiscordBot::Api::Services::Ollama)
  end
  let(:list_local_models_response) { instance_double(RestClient::Response) }
  let(:list_local_models_body) do
    { models: [{ 'name' => 'llama3' }] }.to_json
  end
  let(:chat_response) { instance_double(RestClient::Response) }
  let(:chat_body) { { message: { content: 'Some content' } }.to_json }
  # REVIEW: Silences the logs while running tests
  #         (is there a better way to do this?)
  let(:config) { DiscordBot::Config.new(log_level: :fatal) }

  describe 'generate_response' do
    subject(:generate_response) { conversation.generate_response(message) }

    let(:message) { 'Some message' }

    before do
      allow(api_double).to receive(:ollama).and_return(ollama_service_double)
      allow(ollama_service_double).to receive_messages(list_local_models: list_local_models_response, chat: chat_response)
      allow(list_local_models_response).to receive(:body).and_return(list_local_models_body)
      allow(chat_response).to receive(:body).and_return(chat_body)
    end

    it { should be_a DiscordBot::GenAI::Text::Response }
  end
end

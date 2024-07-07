require 'spec_helper'

RSpec.describe DiscordBot::Bot do
  subject(:bot) { described_class.new(api: api_double) }

  describe 'config' do
    subject(:config) { bot.config }

    it { should be_a DiscordBot::Config }
  end

  describe 'discord_bot' do
    subject(:discord_bot) { bot.discord_bot }

    it { should be_a Discordrb::Bot }
  end

  describe 'conversation' do
    subject(:conversation) { bot.conversation('some_channel_id') }

    it { should be_a DiscordBot::Conversation }
  end

  describe 'commands' do
    subject(:commands) { bot.commands }

    it { should be_an Array }
    it { should all be_a DiscordBot::Command }
  end

  describe 'run' do
    let(:bot) do
      described_class.new(
        discord_bot: discord_bot_double,
        config:      config,
        api:         api_double
      )
    end
    # REVIEW: Silences the logs while running tests
    #         (is there a better way to do this?)
    let(:config) { DiscordBot::Config.new(log_level: :fatal) }
    let(:discord_bot_double) { instance_double(Discordrb::Bot) }
    let(:application_command_double) do
      instance_double(Discordrb::Events::ApplicationCommandEventHandler)
    end

    before do
      allow(discord_bot_double).to receive(:register_application_command)
      allow(discord_bot_double).to receive(:message)
      allow(discord_bot_double).to receive_messages(get_application_commands: [], application_command: application_command_double)
      allow(application_command_double).to receive(:subcommand)
      allow(discord_bot_double).to receive(:invite_url)
      allow(discord_bot_double).to receive(:run).with(true)
      allow(discord_bot_double).to receive(:join)
    end

    it 'sends the join command to Discordrb::Bot' do
      bot.run

      expect(discord_bot_double).to have_received(:join)
    end
  end

  describe 'logger' do
    subject(:logger) { bot.logger }

    it { should be_a DiscordBot::Logger }
  end
end

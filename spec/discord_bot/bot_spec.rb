require 'spec_helper'

RSpec.describe DiscordBot::Bot do
  subject(:bot) { described_class.new }

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
      described_class.new(discord_bot: discord_bot_double, config: config)
    end
    # REVIEW: Silences the logs while running tests
    #         (is there a better way to do this?)
    let(:config) { DiscordBot::Config.new(log_level: :fatal) }
    let(:discord_bot_double) { instance_double(Discordrb::Bot) }
    let(:application_command_double) { double('application_command') }

    before do
      allow(discord_bot_double).to receive(:get_application_commands).and_return([])
      allow(discord_bot_double).to receive(:register_application_command)
      allow(discord_bot_double).to receive(:message)
      allow(discord_bot_double).to receive(:application_command).and_return(application_command_double)
      allow(application_command_double).to receive(:subcommand)
      allow(discord_bot_double).to receive(:invite_url)
      allow(discord_bot_double).to receive(:run).with(true)
    end

    it 'sends the join command to Discordrb::Bot' do
      expect(discord_bot_double).to receive(:join)

      bot.run
    end
  end

  describe 'logger' do
    subject(:logger) { bot.logger }

    it { should be_a DiscordBot::Logger }
  end
end

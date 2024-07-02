require 'spec_helper'

RSpec.describe DiscordBot::Config do
  subject(:config) { described_class.new }

  # HACK: Testing ENV like this feels a bit sketchy
  before do
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:[]).and_call_original
  end

  # Reasons I should move to a standardized logger include, but are not limited
  # to...This mess.
  describe 'log_level?' do
    context 'when log level is :debug' do
      subject(:config) { described_class.new(log_level: :debug) }

      [:debug, :info, :warn, :error, :fatal].each do |log_level|
        it { should be_log_level(log_level) }
      end
    end

    context 'when log level is :info' do
      subject(:config) { described_class.new(log_level: :info) }

      [:info, :warn, :error, :fatal].each do |log_level|
        it { should be_log_level(log_level) }
      end

      [:debug].each do |log_level|
        it { should_not be_log_level(log_level) }
      end
    end

    context 'when log level is :warn' do
      subject(:config) { described_class.new(log_level: :warn) }

      [:warn, :error, :fatal].each do |log_level|
        it { should be_log_level(log_level) }
      end

      [:debug, :info].each do |log_level|
        it { should_not be_log_level(log_level) }
      end
    end

    context 'when log level is :error' do
      subject(:config) { described_class.new(log_level: :error) }

      [:error, :fatal].each do |log_level|
        it { should be_log_level(log_level) }
      end

      [:debug, :info, :warn].each do |log_level|
        it { should_not be_log_level(log_level) }
      end
    end

    context 'when log level is :fatal' do
      subject(:config) { described_class.new(log_level: :fatal) }

      [:fatal].each do |log_level|
        it { should be_log_level(log_level) }
      end

      [:debug, :info, :warn, :error].each do |log_level|
        it { should_not be_log_level(log_level) }
      end
    end
  end

  # NOTE: This is hacky metaprogramming. Do you like it? I don't. :)
  [
    [:admin_user_ids, DiscordBot::Config::DEFAULT_ADMIN_USER_IDS, [1234]],
    [:bot_name, 'Ruby', 'Crystal'],
    [:discord_bot_token, nil, 'asdf'],
    [:discord_bot_intents, :all, [:server_messages]],
    [:fast_boot, false, true],
    [:skip_motd, false, true],
    [
      :slash_command_server_ids,
      DiscordBot::Config::DEFAULT_SLASH_COMMAND_SERVER_IDS,
      [1234]
    ],
    [:log_level, DiscordBot::Config::DEFAULT_LOG_LEVEL, :debug],
    [:log_file_path, DiscordBot::Config::DEFAULT_LOG_FILE_PATH, 'example.log']
  ].each do |config_key, default_value, custom_value|
    it { should respond_to config_key }

    describe config_key.to_s do
      subject(config_key) { config.public_send(config_key.to_s) }

      context 'when using default value' do
        it { should eq(default_value) }
      end

      context 'when overwritten with options' do
        let(:config) { described_class.new(config_key => custom_value) }

        it { should eq(custom_value) }
      end

      context 'when overwritten with ENV' do
        before do
          allow(ENV).to receive(:fetch).with(
            config_key.to_s.underscore.upcase, default_value
          ).and_return(custom_value)
          allow(ENV).to receive(:[]).with(
            config_key.to_s.underscore.upcase
          ).and_return(custom_value)
        end

        it { should eq custom_value }
      end
    end
  end
end

require 'discord_bot'
require 'byebug'
# require 'faker'
require 'shoulda-matchers'

############################
## Generate Test Coverage ##
############################

# TODO: Enable

# # Run specs without checking code coverage with `coverage=false rspec`
# unless ENV['coverage'] == 'false'
#   require 'simplecov'
#
#   SimpleCov.start do
#     # Paths to be ignored
#     add_filter '/spec/'
#
#     # Groups to be tested
#     add_group 'Core', 'sorcery-core/lib'
#     add_group 'JWT', 'sorcery-jwt/lib'
#     add_group 'MFA', 'sorcery-mfa/lib'
#     add_group 'OAuth', 'sorcery-oauth/lib'
#
#     track_files '{sorcery-core, sorcery-mfa, sorcery-oauth}/lib/**/*.{rb}'
#
#     # TODO: Uncomment and implement coverage as needed until met.
#     # SimpleCov.minimum_coverage 95
#     # SimpleCov.minimum_coverage_by_file 50
#   end
# end

#####################
## Configure RSpec ##
#####################

RSpec.configure do |config|
  ######################
  ## RSpec 4 Defaults ##
  ######################

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  ####################
  ## General Config ##
  ####################

  # This allows you to limit a spec run to individual examples or groups
  # you care about by tagging them with `:focus` metadata. When nothing
  # is tagged with `:focus`, all examples get run.
  config.filter_run_when_matching :focus

  # Allows RSpec to persist some state between runs in order to support
  # the `--only-failures` and `--next-failure` CLI options.
  config.example_status_persistence_file_path = 'tmp/rspec_example_status.txt'

  # Limits the available syntax to the non-monkey patched syntax that is
  # recommended. For more details, see:
  # https://rspec.info/features/3-12/rspec-core/configuration/zero-monkey-patching-mode/
  config.disable_monkey_patching!

  # This setting enables warnings. It's recommended, but in some cases may
  # be too noisy due to issues in dependencies.
  config.warnings = true

  # Raise errors on deprecation to provide full stack trace
  config.raise_errors_for_deprecations!

  # Use verbose output formatting when running a single file
  config.default_formatter = 'doc' if config.files_to_run.one?

  # Find slow specs by running `PROFILING=true rspec`
  config.profile_examples = 5 if ENV['PROFILING'] == 'true'

  # Find load order dependencies
  config.order = :random

  # Allow replicating load order dependency by passing in same seed using --seed
  Kernel.srand config.seed
end

################################
## Configure Shoulda Matchers ##
################################
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

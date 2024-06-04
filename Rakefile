# frozen_string_literal: true

require 'bundler/audit/task'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'

Bundler::Audit::Task.new
RuboCop::RakeTask.new
RSpec::Core::RakeTask.new(:spec)

task default: ['bundle:audit:update', 'bundle:audit', :rubocop, :spec]

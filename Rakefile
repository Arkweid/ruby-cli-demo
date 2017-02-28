# For Bundler.with_clean_env
require 'bundler/setup'

import 'packaging/packaging.rake'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

require 'cucumber'
require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features) 

task :default => [:spec, :features]


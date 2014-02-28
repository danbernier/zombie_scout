require 'rake'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new

task :default => :spec

task :console do
  sh('irb -I lib -r zombie_scout')
end

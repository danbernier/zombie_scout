require 'rake'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new

task :default => :spec

task :install_here do
  run = ->(cmd) { puts cmd; `#{cmd}` }
  run['gem build zombie_scout.gemspec']
  run['gem install zombie_scout-*.gem']
end

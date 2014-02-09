require 'thor'
require 'zombie_scout/mission'

module ZombieScout
  class App < Thor
    desc "scout DIRECTORY", "scout for zombie code in DIRECTORY"
    def scout(directory='.')
      Mission.new(directory).scout
    end
  end
end

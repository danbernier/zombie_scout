require 'thor'
require 'zombie_scout/mission'

module ZombieScout
  class App < Thor
    desc "scout", "scout for zombie code in current directory"
    def scout
      Mission.new.scout
    end
  end
end

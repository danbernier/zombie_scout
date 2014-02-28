require 'thor'
require 'zombie_scout/mission'

module ZombieScout
  class App < Thor
    desc "scout", "scout for zombie code in current directory"
    def scout(*globs)
      start_time = Time.now
      mission = Mission.new(globs)
      report = mission.scout
      report.each do |zombie|
        puts [zombie[:location], zombie[:name], zombie[:flog_score]] * "\t"
      end
      duration = Time.now - start_time
      puts "Scouted #{mission.defined_method_count} methods in #{mission.sources.size} files, in #{duration} seconds."
      puts "Found #{report.size} potential zombies."
    end
  end
end

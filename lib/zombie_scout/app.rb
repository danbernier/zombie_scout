require 'thor'
require 'zombie_scout/mission'

module ZombieScout
  class App < Thor
    desc "scout", "scout for zombie code in current directory"
    def scout(*globs)
      mission = Mission.new(globs)
      report = mission.scout.sort_by { |z| -z[:flog_score] }
      total_flog_score = report.map { |z| z[:flog_score] }.reduce(:+)

      puts "Scouted #{mission.defined_method_count} methods in #{mission.source_count} files, in #{mission.duration} seconds."
      puts "Found #{report.size} potential zombies, with a combined flog score of #{total_flog_score.round(1)}."
      puts

      report.each do |zombie|
        puts [zombie[:location], zombie[:name], zombie[:flog_score]] * "\t"
      end
    end
  end
end

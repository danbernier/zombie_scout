require 'thor'
require 'zombie_scout/mission'

module ZombieScout
  class App < Thor
    desc "scout", "scout for zombie code in current directory"
    option :format, enum: %w(report csv), default: 'report'
    def scout(*globs)
      mission = Mission.new(globs)
      report = mission.scout.sort_by { |z| -z[:flog_score] }

      if options[:format] == 'report'
        total_flog_score = report.map { |z| z[:flog_score] }.reduce(0, :+)

        puts "Scouted #{mission.defined_method_count} methods in #{mission.source_count} files, in #{mission.duration} seconds."
        puts "Found #{mission.zombie_count} potential zombies, with a combined flog score of #{total_flog_score.round(1)}."
        puts

        report.each do |zombie|
          puts [zombie[:location], zombie[:full_name], zombie[:flog_score]] * "\t"
        end
      elsif options[:format] == 'csv'
        require 'csv'
        CSV do |csv|
          csv << %w(location name flog_score)
          report.each do |zombie|
            csv << [zombie[:location], zombie[:full_name], zombie[:flog_score]]
          end
        end
      end
    end
  end
end

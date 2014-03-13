require 'thor'
require 'zombie_scout/mission'
require 'zombie_scout/formatter'

module ZombieScout
  class App < Thor
    desc "scout", "scout for zombie code in current directory"
    option :format, enum: %w(report csv), default: 'report'
    def scout(*globs)
      mission = Mission.new(globs)
      report = mission.scout.sort_by { |z| [z[:file_path], -z[:flog_score]] }

      ZombieScout::Formatter.format(options[:format], mission, report)
    end
  end
end

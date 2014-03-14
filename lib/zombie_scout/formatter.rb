module ZombieScout
  module Formatter
    def self.format(format, mission, report)
      formatter_class_name = "#{format.capitalize}Formatter"
      formatter_class = const_get(formatter_class_name)
      formatter_class.new(mission, report).to_s
    end

    class BaseFormatter
      attr_reader :mission, :report
      def initialize(mission, report)
        @mission, @report = mission, report
      end
    end

    class ReportFormatter < BaseFormatter
      def to_s
        one = "Scouted #{mission.defined_method_count} methods in #{mission.source_count} files, in #{mission.duration} seconds."
        two = "Found #{mission.zombie_count} potential zombies, with a combined flog score of #{total_flog_score.round(1)}."

        ([one, two, "\n"] + report.map { |zombie|
          [zombie[:location], zombie[:full_name], zombie[:flog_score]] * "\t"
        }) * "\n"
      end

      def total_flog_score
        report.map { |z| z[:flog_score] }.reduce(0, :+)
      end
    end

    class CsvFormatter < BaseFormatter
      def to_s
        require 'csv'
        CSV.generate do |csv|
          csv << %w(location name flog_score)
          report.each do |zombie|
            csv << [zombie[:location], zombie[:full_name], zombie[:flog_score]]
          end
        end
      end
    end
  end
end

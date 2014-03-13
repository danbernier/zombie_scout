module ZombieScout
  module Formatter
    def self.format(format, mission, report, io=STDOUT)
      if format == 'report'
        ReportFormatter.new(mission, report, io).to_s
      elsif format == 'csv'
        CsvFormatter.new(mission, report, io).to_s
      end
    end

    class BaseFormatter
      attr_reader :mission, :report, :io
      def initialize(mission, report, io)
        @mission, @report, @io = mission, report, io
      end
    end

    class ReportFormatter < BaseFormatter
      def to_s
        io.puts "Scouted #{mission.defined_method_count} methods in #{mission.source_count} files, in #{mission.duration} seconds."
        io.puts "Found #{mission.zombie_count} potential zombies, with a combined flog score of #{total_flog_score.round(1)}."
        io.puts

        report.each do |zombie|
          io.puts [zombie[:location], zombie[:full_name], zombie[:flog_score]] * "\t"
        end
      end

      def total_flog_score
        report.map { |z| z[:flog_score] }.reduce(0, :+)
      end
    end

    class CsvFormatter < BaseFormatter
      def to_s
        require 'csv'
        csv = CSV.new(io)
        csv << %w(location name flog_score)
        report.each do |zombie|
          csv << [zombie[:location], zombie[:full_name], zombie[:flog_score]]
        end
      end
    end
  end
end

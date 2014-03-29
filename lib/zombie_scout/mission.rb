require 'zombie_scout/ruby_project'
require 'zombie_scout/parser'
require 'zombie_scout/method_call_finder'
require 'zombie_scout/flog_scorer'

module ZombieScout
  class Mission
    attr_reader :defined_method_count

    def initialize(globs)
      @ruby_project = RubyProject.new(*globs)
    end

    def scout
      @start_time = Time.now
      zombies.map { |zombie|
        { location: zombie.location,
          file_path: zombie.file_path,
          name: zombie.name,
          full_name: zombie.full_name,
          flog_score: flog_score(zombie)
        }
      }.tap {
        @end_time = Time.now
      }
    end

    def duration
      @end_time - @start_time
    end

    def source_count
      sources.size
    end

    def zombie_count
      zombies.size
    end

    private

    def sources
      @sources ||= @ruby_project.ruby_sources
    end

    def flog_score(zombie)
      ZombieScout::FlogScorer.new(zombie).score
    end

    def zombies
      return @zombies unless @zombies.nil?

      scout!
      @zombies = @defined_methods.select { |method|
        might_be_dead?(method)
      }
    end

    def scout!
      @defined_methods, @called_methods = [], []

      sources.each do |ruby_source|
        parser = ZombieScout::Parser.new(ruby_source)
        @defined_methods.concat(parser.defined_methods)
        @called_methods.concat(parser.called_methods)
      end

      @defined_method_count = @defined_methods.size

      @called_methods.uniq!
      @defined_methods.reject! do |method|
        @called_methods.include?(method.name)
      end
    end

    def might_be_dead?(method)
      @method_call_counter ||= MethodCallFinder.new(@ruby_project)
      @method_call_counter.count_calls(method.name) < 2
    end
  end
end

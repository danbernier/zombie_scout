require 'zombie_scout/ruby_project'
require 'zombie_scout/parser'
require 'zombie_scout/method_call_finder'

module ZombieScout
  class Mission
    def initialize(globs)
      puts "Scouting out #{Dir.pwd}!"
      @ruby_project = RubyProject.new(*globs)
    end

    def scout
      start_time = Time.now
      zombies.each do |zombie|
        puts [zombie.location, zombie.name] * "\t"
      end
      duration = Time.now - start_time

      puts "Scouted #{methods.size} methods in #{sources.size} files, in #{duration}."
      puts "Found #{zombies.size} potential zombies."
    end

    private

    def zombies
      return @zombies unless @zombies.nil?

      scout!
      @zombies ||= @defined_methods.select { |method|
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

      @called_methods.uniq!
      @defined_methods.reject! do |method|
        @called_methods.include?(method.name)
      end
    end

    def sources
      @sources ||= @ruby_project.ruby_sources
    end

    def might_be_dead?(method)
      @method_call_counter ||= MethodCallFinder.new(@ruby_project)
      @method_call_counter.count_calls(method.name) < 2
    end
  end
end

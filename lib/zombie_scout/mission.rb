require 'zombie_scout/ruby_project'
require 'zombie_scout/method_finder'
require 'zombie_scout/method_call_finder'

module ZombieScout
  class Mission
    def initialize
      puts "Scouting out #{Dir.pwd}!"
      @ruby_project = RubyProject.new
    end

    def scout
      zombies.each do |zombie|
        puts [zombie.location, zombie.name] * "\t"
      end

      puts "Scouted #{methods.size} methods in #{sources.size} files. Found #{zombies.size} potential zombies."
    end

    private

    def zombies
      @zombies ||= methods.select { |method|
        might_be_dead?(method)
      }
    end

    def methods
      @methods ||= sources.map { |ruby_source|
        methods = MethodFinder.new(ruby_source).find_methods
      }.flatten
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

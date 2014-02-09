require 'zombie_scout/ruby_project'
require 'zombie_scout/method_finder'
require 'zombie_scout/method_call_finder'

module ZombieScout
  class Mission
    def initialize(project_dir)
      puts "Scouting out #{project_dir}!"
      @ruby_project = RubyProject.new(project_dir)
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
      @method_call_counter ||= MethodCallFinder.new
      @method_call_counter.count_calls(method.name) < 2
    end 
  end
end

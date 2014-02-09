require 'zombie_scout/ruby_source'

module ZombieScout
  class RubyProject

    def initialize(root_dir)
      @root_dir = root_dir
    end

    def ruby_sources
      Dir.glob(File.join(@root_dir, '**/*.rb')).map { |path|
        path = path.sub(/^\/#{@root_dir}\//, '')
        RubySource.new(path)
      }
    end
  end
end

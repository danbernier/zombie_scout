require 'zombie_scout/ruby_source'

module ZombieScout
  class RubyProject

    def initialize(root_dir)
      @root_dir = root_dir
    end

    def ruby_sources
      Dir.glob(File.join(@root_dir, glob)).map { |path|
        path = path.sub(/^\/#{@root_dir}\//, '')
        RubySource.new(path)
      }
    end

    def glob
      "{#{folders.join(',')}}/**/*.rb"
    end

    def folders
      %w[app lib]
    end
  end
end

require 'zombie_scout/ruby_source'

module ZombieScout
  class RubyProject

    def initialize(root_dir)
      @root_dir = root_dir
    end

    def ruby_sources
      ruby_file_paths.map { |path| RubySource.new(path) }
    end

    def ruby_file_paths
      Dir.glob(glob).map { |path|
        path.sub(/^\/#{@root_dir}\//, '')
      }
    end

    def glob
      File.join(@root_dir,  "{#{folders.join(',')}}/**/*.rb")
    end

    def folders
      %w[app lib]
    end
  end
end

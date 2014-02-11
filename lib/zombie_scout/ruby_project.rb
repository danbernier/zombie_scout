require 'zombie_scout/ruby_source'

module ZombieScout
  class RubyProject

    def ruby_sources
      ruby_file_paths.map { |path| RubySource.new(path) }
    end

    def ruby_file_paths
      Dir.glob(glob).map { |path|
        path.sub(/^\//, '')
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

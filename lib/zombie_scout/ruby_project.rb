require 'zombie_scout/ruby_source'
require 'pathname'

module ZombieScout
  class RubyProject

    def initialize(*globs)
      @globs = globs
      @globs = %w[app lib] if @globs.empty?
    end

    def ruby_sources
      ruby_file_paths.map { |path| RubySource.new(path) }
    end

    def ruby_file_paths
      globs.map { |glob| Dir.glob(glob) }.flatten.map { |path|
        path.sub(/^\//, '')
      }
    end

    def globs
      pathnames = @globs.map { |g| Pathname.new(g) }
      pathnames.map { |pathname|
        if pathname.directory?
          "#{pathname}/**/*.rb"
        else
          pathname.to_s
        end
      }
    end

    def folders
      %w[app lib]
    end
  end
end

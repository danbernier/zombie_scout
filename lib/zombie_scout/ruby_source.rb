module ZombieScout
  class RubySource
    def initialize(filename)
      @path = filename
    end

    attr_reader :path

    def source
      @source ||= File.read(path)
    end
  end
end

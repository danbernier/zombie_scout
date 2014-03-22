module ZombieScout
  class MethodCallFinder

    def initialize(ruby_project)
      @ruby_project = ruby_project
    end

    def count_calls(method_name)
      method_name = method_name.to_s
      method_name.sub!(/=$/, ' *=')
      find_occurrances(method_name).size
    end

    private

    def find_occurrances(method_name)
      # TODO somehow expose some of this config for end-users
      command = "grep -rnw #{includes} --binary-files=without-match \"#{method_name}\" #{files_to_search}"
      grep_lines = `#{command}`
      grep_lines.split("\n")
    end

    def includes
      %w(*.rb *.erb *.rake).map { |inc|
        "--include=\"#{inc}\""
      }.join(' ')
    end

    def files_to_search
      @ruby_project.folders.join(' ')
    end
  end
end

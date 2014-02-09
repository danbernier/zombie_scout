module ZombieScout
  class MethodCallFinder
    def count_calls(method_name)
      method_name = method_name.to_s
      method_name.sub!(/=$/, ' *=')
      find_occurrances(method_name).size
    end

    private

    def find_occurrances(method_name)
      # TODO somehow expose some of this config for end-users
      grep_lines = `grep #{method_name} -rnw #{folders_to_search} --include=*.rb` 
      # --include=*.{rb,erb,rake}`

      grep_lines.split("\n")
    end

    def folders_to_search
      #"#{@root_dir}/app #{@root_dir}/lib #{@root_dir}/config"
      @root_dir
    end
  end
end

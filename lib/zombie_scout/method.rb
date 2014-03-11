module ZombieScout
  class Method < Struct.new(:name, :class_name, :file_path, :line_number)
    def full_name
      [class_name, '#', name].join('')
    end

    def location
      [file_path, line_number].join(':')
    end
  end
end

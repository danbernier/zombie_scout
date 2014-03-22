require 'thor'
require 'zombie_scout/mission'
require 'zombie_scout/formatter'

module ZombieScout
  class App < Thor
    desc "scout", "scout for zombie code in current directory"
    option :format, enum: %w(report csv), default: 'report'
    def scout(*globs)
      mission = Mission.new(globs)
      report = mission.scout.sort_by { |z| [z[:file_path], -z[:flog_score]] }

      puts ZombieScout::Formatter.format(options[:format], mission, report)
    end

    desc "playing", 'hacking on thor to see what it can do'
    def playing(*thingy)
      #say(thingy, :green) #:blue) #:red) # :yellow

      require 'optparse'
      require 'pp'
      require 'ostruct'
      require 'shellwords'
   
      pp ZombieScoutConfigParser.parse(project_configuration + ARGV)   
    end

    no_tasks do
      def project_configuration
        args_from_options_file('.zombie_scout') 
      end

      def args_from_options_file(path)
        return [] unless File.exist?(path)
        config_string = File.read(path)
        config_string.split(/\n+/).flat_map(&:shellsplit)
      end
    end
  end
end

module ZombieScoutConfigParser
  def self.parse(args)
    options = OpenStruct.new
    options.grep_include = '*.rb'

    opt_parser = OptionParser.new do |opts|

      opts.on('--grep-exclude=FILE_PATTERN', 
              'When grepping, skip files and directories matching FILE_PATTERN') do |pattern|
        options.grep_exclude = pattern
      end

      opts.on('--grep-include=FILE_PATTERN',
              'When grepping, search only files that match FILE_PATTERN') do |pattern|
        options.grep_include = pattern
      end

      opts.on('--grep-exclude-dir=PATTERN',
              'When grepping, directories that match PATTERN will be skipped.') do |pattern|
        options.grep_exclude_dir = pattern
      end
    end

    opt_parser.parse!(args)
    options 
  end
end

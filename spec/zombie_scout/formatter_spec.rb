require 'spec_helper'
require 'zombie_scout/formatter'

describe ZombieScout::Formatter do
  let(:mission) {
    double(:mission, defined_method_count: 123,
                     source_count: 97,
                     zombie_count: 42,
                     duration: 55)
  }

  let(:report) {
    [
      { flog_score: 23.4,
        location: 'foo.rb:42',
        full_name: 'Foo#bar' },
      { flog_score: 43.2,
        location: 'bar.rb:99',
        full_name: 'Bar#none' }
    ]
  }

  context 'for "report" format' do
    it 'formats it correctly' do
      output = capture_output do |out|
        ZombieScout::Formatter.format('report', mission, report, out)
      end

      expect(output).to include "Scouted 123 methods in 97 files"
      expect(output).to include "in 55 seconds"
      expect(output).to include "Found 42 potential zombies"
      expect(output).to include "combined flog score of 66.6"
      expect(output).to include "foo.rb:42\tFoo#bar\t23.4"
      expect(output).to include "bar.rb:99\tBar#none\t43.2"
    end
  end

  context 'for "csv" format' do
    it 'formats it correctly' do
      output = capture_output do |out|
        ZombieScout::Formatter.format('csv', mission, report, out)
      end

      lines = output.split("\n").map(&:chomp)
      expect(lines).to eq([
        'location,name,flog_score',
        'foo.rb:42,Foo#bar,23.4',
        'bar.rb:99,Bar#none,43.2'
      ])
    end
  end

  context 'for a custom format' do
    it 'delegates to the new custom format' do
      eval("
           class ::ZombieScout::Formatter::CustomFormatter
             def initialize(mission, report, io)
               @io = io
             end
             def to_s
               @io.puts 'papercuts'
             end
           end
           ")

      output = capture_output do |out|
        ZombieScout::Formatter.format('custom', mission, report, out)
      end
      expect(output).to eq("papercuts\n")
    end
  end
end

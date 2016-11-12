require 'spec_helper'
require 'zombie_scout/ruby_source'

describe ZombieScout::RubySource do
  include FakeFS::SpecHelpers

  let(:ruby_code) do
    "
    class RubyCode
      def awesome?
        true
      end
    end
    "
  end

  let(:filename) { 'ruby_code.rb' }

  let(:ruby_source) {
    File.open(filename, 'w') { |f| f << ruby_code }
    ZombieScout::RubySource.new(filename)
  }

  describe '#path' do
    it 'should equal the filename' do
      expect(ruby_source.path).to eq(filename)
    end
  end
  describe '#source' do
    it 'should equal the ruby_code' do
      expect(ruby_source.source).to eq(ruby_code)
    end
  end
end

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

  subject do
    File.open(filename, 'w') { |f| f << ruby_code }
    ZombieScout::RubySource.new(filename)
  end

  its(:path) { should eq(filename) }
  its(:source) { should eq(ruby_code) }
end

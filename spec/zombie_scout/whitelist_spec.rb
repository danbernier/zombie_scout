require 'spec_helper'
require 'zombie_scout/whitelist'

describe ZombieScout::Whitelist do
  include FakeFS::SpecHelpers

  def clear_whitelist!
    if File.exist?('.zombie_scout_whitelist')
      File.delete('.zombie_scout_whitelist')
    end
  end

  def whitelist!(*names)
    File.open('.zombie_scout_whitelist', 'w') do |f|
      f.puts names.join("\n")
    end
  end

  let(:whitelist) { ZombieScout::Whitelist.new }

  describe '#include?' do
    it 'only includes methods listed in .zombie_scout_whitelist' do
      whitelist! 'Foo#bar', 'Iron#man'
      expect(whitelist).to include('Foo#bar')
      expect(whitelist).to include('Iron#man')
      expect(whitelist).not_to include('Cran#berry')
      expect(whitelist).not_to include('Boot#laces')
    end

    it 'includes nothing when .zombie_scout_whitelist does not exist' do
      clear_whitelist!
      expect(whitelist).not_to include('Foo#bar')
      expect(whitelist).not_to include('Iron#man')
      expect(whitelist).not_to include('Cran#berry')
      expect(whitelist).not_to include('Boot#laces')
    end
  end
end

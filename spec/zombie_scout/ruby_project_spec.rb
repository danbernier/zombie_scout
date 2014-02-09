require 'spec_helper'

require 'zombie_scout/ruby_project'

describe ZombieScout::RubyProject, '#ruby_sources' do
  include FakeFS::SpecHelpers

  def touch(path)
    FileUtils.mkdir_p(File.dirname(path))
    FileUtils.touch(path)
  end

  it 'returns a RubySource for each *.rb under the root dir' do
    files = [
      'lib/ironman/jarvis.rb',
      'lib/ironman/suit.rb',
      'lib/ironman/tower.rb'
    ]

    files.each { |file| touch('ironman/' + file) }

    sources = ZombieScout::RubyProject.new('ironman').ruby_sources
    expect(sources.map(&:path)).to eq(files)
  end
end

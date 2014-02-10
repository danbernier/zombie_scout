require 'spec_helper'

require 'zombie_scout/ruby_project'

describe ZombieScout::RubyProject, '#ruby_sources' do
  include FakeFS::SpecHelpers

  def touch(path)
    FileUtils.mkdir_p(File.dirname(path))
    FileUtils.touch(path)
  end

  context 'in a normal ruby project' do
    it 'returns a RubySource for each *.rb under the lib dir' do
      files = [
        'lib/ironman/jarvis.rb',
        'lib/ironman/suit.rb',
        'spec/ironman/jarvis_spec.rb',
        'test/ironman/test_suit.rb'
      ]

      files.each { |file| touch('ironman/' + file) }

      sources = ZombieScout::RubyProject.new('ironman').ruby_sources
      expect(sources.map(&:path)).to eq [
        'lib/ironman/jarvis.rb',
        'lib/ironman/suit.rb'
      ]
    end
  end

  context 'in a rails project' do
    it 'returns a RubySource for each *.rb under lib and app' do
      files = [
        'app/models/suit.rb',
        'app/controllers/suits_controller.rb',
        'spec/views/suit_view_spec.rb',
        'test/models/test_suit.rb'
      ]

      files.each { |file| touch('ironman/' + file) }

      sources = ZombieScout::RubyProject.new('ironman').ruby_sources
      expect(sources.map(&:path).sort).to eq [
        'app/controllers/suits_controller.rb',
        'app/models/suit.rb'
      ]
    end
  end
end

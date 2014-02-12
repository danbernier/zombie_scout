require 'spec_helper'

require 'zombie_scout/ruby_project'

describe ZombieScout::RubyProject, '#globs' do
  include FakeFS::SpecHelpers
  before do
    FileUtils.mkdir('lib')
    FileUtils.touch('lib/app.rb')
  end

  context 'when given a dirname' do
    it 'appends **/*.rb' do
      project = ZombieScout::RubyProject.new('lib')
      expect(project.globs).to eq ['lib/**/*.rb']
    end
  end

  context 'when given a globs' do
    it 'leaves it alone' do
      project = ZombieScout::RubyProject.new('lib/*.rb')
      expect(project.globs).to eq ['lib/*.rb']
    end
  end

  context 'when given a file path' do
    it 'leaves it alone' do
      project = ZombieScout::RubyProject.new('lib/app.rb')
      expect(project.globs).to eq ['lib/app.rb']
    end
  end
end

describe ZombieScout::RubyProject, '#ruby_sources' do
  include FakeFS::SpecHelpers

  def touch(path)
    FileUtils.mkdir_p(File.dirname(path))
    FileUtils.touch(path)
  end

  context 'in a normal ruby project' do
    let(:files) do
      [
        'lib/ironman/jarvis.rb',
        'lib/ironman/suit.rb',
        'lib/hulk/green/smash.rb',
        'spec/ironman/jarvis_spec.rb',
        'test/ironman/test_suit.rb'
      ]
    end
    before do
      files.each do |file|
        touch(file)
      end
    end

    context 'without globs' do
      it 'returns a RubySource for each *.rb under the lib dir' do
        sources = ZombieScout::RubyProject.new.ruby_sources
        expect(sources.map(&:path).sort).to eq [
          'lib/hulk/green/smash.rb',
          'lib/ironman/jarvis.rb',
          'lib/ironman/suit.rb',
        ]
      end
    end

    context 'with globs' do
      it 'returns a RubySource for each *.rb matching the globs' do
        sources = ZombieScout::RubyProject.new('lib/**/jarv*').ruby_sources
        expect(sources.map(&:path)).to eq [
          'lib/ironman/jarvis.rb'
        ]
      end
    end

    context 'with directory names' do
      it 'returns a RubySource for each *.rb (recursively) in the dir' do
        sources = ZombieScout::RubyProject.new('lib/hulk').ruby_sources
        expect(sources.map(&:path)).to eq [
          'lib/hulk/green/smash.rb'
        ]
      end
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

      files.each { |file| touch(file) }

      sources = ZombieScout::RubyProject.new.ruby_sources
      expect(sources.map(&:path).sort).to eq [
        'app/controllers/suits_controller.rb',
        'app/models/suit.rb'
      ]
    end
  end
end

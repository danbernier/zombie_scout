require 'spec_helper'
require 'zombie_scout/method_finder'

describe ZombieScout::MethodFinder, '#find_methods' do
  let(:ruby_source) {
    double(:ruby_source, path: 'lib/fizzbuzz.rb', source: ruby_code)
  }
  let(:zombies) {
    ZombieScout::MethodFinder.new(ruby_source).find_methods.sort_by(&:name)
  }

  context 'when a ruby file has instance or class methods' do
    let(:ruby_code) {
      "class FizzBuzz
         def fizz
           'plop plop'
         end

         def self.buzz
           'bzz bzz bzz'
         end
       end"
    }

    it 'can find the methods' do
      expect(zombies[0].name).to eq :buzz
      expect(zombies[0].location).to eq 'lib/fizzbuzz.rb:6'

      expect(zombies[1].name).to eq :fizz
      expect(zombies[1].location).to eq 'lib/fizzbuzz.rb:2'
    end
  end

  context 'when a ruby file has attr_readers' do
    let(:ruby_code) { 
      "class Book
         attr_reader :title, :author
       end"
    }

    it 'can find attr_readers' do
      expect(zombies.map(&:name)).to eq(%i[author title])
    end
  end

  context 'when a ruby file has attr_writers' do
    let(:ruby_code) { 
      "class Book
         attr_writer :title, :author
       end"
    }
    it 'can find attr_writers' do
      expect(zombies.map(&:name)).to eq(%i[author= title=])
    end
  end

  context 'when a ruby file has attr_accessors' do
    let(:ruby_code) {
      "class Book
         attr_accessor :title, :author
       end"
    }
    it 'can find attr_accessors' do
      expect(zombies.map(&:name)).to eq(%i[author author= title title=])
    end
  end

  context 'when a ruby file uses Forwardable::def_delegator' do
    let(:ruby_code) { 
      "class RecordCollection
         extend Forwardable
         def_delegator :@records, :[], :record_number
       end"
    }
    it 'can find methods created by def_delegator' do
      expect(zombies.map(&:name)).to match_array([:record_number])
    end
  end

  context 'when a ruby file uses Forwardable::def_delegators' do
    let(:ruby_code) {
      "class RecordCollection
         extend Forwardable
         def_delegators :@records, :size, :<<, :map
       end"
    }
    it 'can find methods created by def_delegators' do
      expect(zombies.map(&:name)).to eq(%i[<< map size])
    end
  end

  context 'when a ruby file has private methods' do
    let(:ruby_code) {
      "class FizzBuzz
         def fizz
           magick_helper
         end

         private
         def magick_helper
           'magick sauce'
         end
      end"
    }
    it 'excludes private method calls, since we KNOW they are called' do
      expect(zombies.map(&:name)).to match_array([:fizz])
      expect(zombies.map(&:name)).not_to include :magick_helper
    end
  end
end

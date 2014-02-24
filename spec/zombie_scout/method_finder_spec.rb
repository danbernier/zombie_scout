require 'spec_helper'

require 'zombie_scout/method_finder'

describe ZombieScout::MethodFinder, '#find_methods' do
  it 'can find methods in ruby source' do
    ruby_code = "
    class FizzBuzz
      def fizz
        'plop plop'
      end

      def self.buzz
        'bzz bzz bzz'
      end
    end
    "
    ruby_source = double(:ruby_source, path: 'lib/fizzbuzz.rb', source: ruby_code)

    methods = ZombieScout::MethodFinder.new(ruby_source).find_methods.sort_by(&:name)

    expect(methods[0].name).to eq :buzz
    expect(methods[0].location).to eq 'lib/fizzbuzz.rb:7'

    expect(methods[1].name).to eq :fizz
    expect(methods[1].location).to eq 'lib/fizzbuzz.rb:3'
  end

  it 'excludes private method calls, since we KNOW they are called' do
    ruby_code = "
      class FizzBuzz
        def fizz
          magick_helper
        end

        private
        def magick_helper
          'magick sauce'
        end
      end
    "
    ruby_source = double(:ruby_source, path: 'lib/fizzbuzz.rb', source: ruby_code)

    methods = ZombieScout::MethodFinder.new(ruby_source).find_methods

    expect(methods.size). to eq 1
    expect(methods[0].name).to eq :fizz
    expect(methods.map(&:name)).not_to include :magick_helper
  end
end

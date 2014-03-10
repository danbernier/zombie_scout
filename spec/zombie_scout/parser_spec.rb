require 'spec_helper'
require 'zombie_scout/parser'

describe ZombieScout::Parser do
  let(:file_name) { 'lib/fizzbuzz.rb' }
  let(:ruby_source) {
    double(:ruby_source, path: file_name, source: ruby_code)
  }

  describe '#called_methods' do
    let(:called_methods) {
      ZombieScout::Parser.new(ruby_source).called_methods
    }
    context 'when a ruby file has code that calls methods' do
      let(:ruby_code) {
        "class RockBand
           def rock_out
             turn_up_amps
             play_tunes
           end
         end"
      }
      it 'can find the called methods' do
        expect(called_methods).to match_array %i(play_tunes turn_up_amps)
      end
    end
  end

  describe '#defined_methods' do
    let(:defined_methods) {
      ZombieScout::Parser.new(ruby_source).defined_methods.sort_by(&:name)
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

      it 'can find the methods, and the class and file they belong to' do
        expect(defined_methods.size).to eq 2

        expect(defined_methods[0].name).to eq :buzz
        expect(defined_methods[0].full_name).to eq 'FizzBuzz#buzz'
        expect(defined_methods[0].location).to eq 'lib/fizzbuzz.rb:6'

        expect(defined_methods[1].name).to eq :fizz
        expect(defined_methods[1].full_name).to eq 'FizzBuzz#fizz'
        expect(defined_methods[1].location).to eq 'lib/fizzbuzz.rb:2'
      end
    end

    context 'when a ruby file has methods in a module' do
      let(:file_name) { 'fizz.rb' }
      let(:ruby_code) {
        "module Fizz
           def berries
             'fizz berries?'
           end
         end"
      }
      it 'can find the methods, and the module they belong to' do
        expect(defined_methods.size).to eq 1
        expect(defined_methods[0].name).to eq :berries
        expect(defined_methods[0].full_name).to eq 'Fizz#berries'
        expect(defined_methods[0].location).to eq 'fizz.rb:2'
      end
    end

    context 'when a ruby file has a class nested in a module' do
      let(:file_name) { 'zombie.rb' }
      let(:ruby_code) {
        "module Zombie
           class Report
             def info
               'all clear!'
             end
           end
         end"
      }
      it 'will record the nesting in the classname' do
        expect(defined_methods.size).to eq 1
        expect(defined_methods[0].name).to eq :info
        expect(defined_methods[0].full_name).to eq 'Zombie::Report#info'
        expect(defined_methods[0].location).to eq 'zombie.rb:3'
      end
    end

    context 'when a ruby file has a class nested in another class' do
      let(:ruby_code) {
        "class Person
           class Address
             def street
               '123 main'
             end
           end
         end"
      }
      it 'will record the nesting in the classname' do
        expect(defined_methods[0].full_name).to eq 'Person::Address#street'
      end
    end

    context 'when a ruby file has attr_readers' do
      context "when they're declared with symbols, the normal way" do
        let(:ruby_code) {
          "class Book
             attr_reader :title, :author
           end"
        }
        it 'can find attr_readers' do
          expect(defined_methods.map(&:name)).to match_array(%i[author title])
        end
      end
      context "when they're declare with a splat from an array of symbols" do
        let(:ruby_code) {
          "class Book
             attributes = %i(title author)
             attr_reader *attributes
           end"
        }
        it 'will ignore them' do
          expect(defined_methods).to be_empty
        end
      end
    end

    context 'when a ruby file has attr_writers' do
      context "when they're declared with symbols, the normal way" do
        let(:ruby_code) {
          "class Book
             attr_writer :title, :author
           end"
        }
        it 'can find attr_writers' do
          expect(defined_methods.map(&:name)).to match_array(%i[author= title=])
        end
      end
      context "when they're declare with a splat from an array of symbols" do
        let(:ruby_code) {
          "class Book
             attributes = %i(title author)
             attr_reader *attributes
           end"
        }
        it 'will ignore them' do
          expect(defined_methods).to be_empty
        end
      end
    end

    context 'when a ruby file has attr_accessors' do
      context "when they're declared with symbols, the normal way" do
        let(:ruby_code) {
          "class Book
             attr_accessor :title, :author
           end"
        }
        it 'can find attr_accessors' do
          expect(defined_methods.map(&:name)).to match_array(%i[author author= title title=])
        end
      end
      context "when they're declare with a splat from an array of symbols" do
        let(:ruby_code) {
          "class Book
             attributes = %i(title author)
             attr_accessor *attributes
           end"
        }
        it 'will ignore them' do
          expect(defined_methods).to be_empty
        end
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
        expect(defined_methods.map(&:name)).to match_array([:record_number])
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
        expect(defined_methods.map(&:name)).to match_array(%i[<< map size])
      end
    end

    context 'when a rails model has scopes' do
      let(:ruby_code) {
        "class Post
           scope :published, -> { where(published: true) }
           scope :draft, -> { where(published: true) }
         end"
      }
      it 'can find scopes' do
        expect(defined_methods.map(&:name)).to match_array(%i[draft published])
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

           def other_helper
             'boo'
           end
         end"
      }
      it 'excludes private method calls, since we KNOW they are called' do
        expect(defined_methods.map(&:name)).to match_array([:fizz, :magick_helper, :other_helper])
      end
    end
  end
end

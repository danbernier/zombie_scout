zombie_scout
=============

Find dead methods in your Ruby app

**zom·bie code** *noun* Undead code that shambles around your repository, and
eats your brains.

You don't want zombie code around. But you can't spend all your time looking
for it. So get yourself a Zombie Scout.

Zombie Scout is light & quick. Its only tools are `parser` and `grep`.  It
parses your code to find method declarations, and then greps through your
project's source, looking for each method.  If Zombie Scout can't find any
calls to a method, it presumes the method is dead, and reports back to you.

### How Does It Work?

#### Phase 1: Parse

Zombie Scout parses your ruby files, and remembers all the methods it sees
defined.

#### Phase 2: Grep

Then it greps your whole project - currently *.rb and *.erb *.haml files - for
whole-word occurrances of any of the methods it found. The whole-word grep
(`grep -w`) means that searching for `dead_method` won't count `dead_methods`
as a match, and accidentally think it's live.

So, if you have 1,000 methods, you have to run 1,000 greps? That's slow, right?
Good news: back in Phase 1, when Zombie Scout parsed your code, it also
remembered all the method CALLS it saw, and it automatically counts those
methods as not-zombies, so it saves a bunch of time by not grepping for them.

#### Fair Warning

Zombie Scout isn't exhaustive or thorough - it's a scout, not a spy. (That
could be another project, though - a Zombie Spy.)

If you generate methods in a way that's hard to grep for...

    method_name = ['s', 'e', 'c', 'r', 'e', 't']
    object.send(method_name.join(''))

...then Zombie Scout won't find it. Remember: light & quick.

That said, it *will* find methods defined with `attr_reader` & friends, or
`Forwardable` delegates, or Rails scopes.  Rails delegators are on the To-Do
list.

If you have methods that are used by another library - say, callbacks - Zombie
Scout will probably think they're dead, because it's not looking at the source
for that other library.

Finally, if you have a method named after a common human-language word, and
that word appears in (say) hard-coded strings or comments, Zombie Scout will
think it's calling the method, and assume that the method is used.

    # this is an awesome method!   <-- false positive right there
    def awesome
      'AWESOME!'
    end

Be wise.

## Installation

The basics:

    gem install 'zombie_scout'

Or, add this to your Gemfile:

    gem 'zombie_scout'

## Usage

### From the Command Line

You can run it on a whole folder:

    dan@aleph:~/projects/zombie_scout$ zombie_scout scout
    Scouted 48 methods in 10 files, in 1.470468836 seconds.
    Found 13 potential zombies, with a combined flog score of 66.9.

    lib/zombie_scout/parser.rb:45   ZombieScout::Parser#on_send     8.3
    lib/zombie_scout/parser.rb:17   ZombieScout::Parser#on_class    7.9
    lib/zombie_scout/parser.rb:25   ZombieScout::Parser#on_module   7.2
    lib/zombie_scout/parser.rb:39   ZombieScout::Parser#on_defs     5.9
    lib/zombie_scout/parser.rb:81   ZombieScout::Parser#handle_def_delegators       5.8
    lib/zombie_scout/parser.rb:72   ZombieScout::Parser#handle_attr_accessor        5.6
    lib/zombie_scout/parser.rb:33   ZombieScout::Parser#on_def      4.9
    lib/zombie_scout/parser.rb:56   ZombieScout::Parser#handle_attr_reader  4.3
    lib/zombie_scout/parser.rb:64   ZombieScout::Parser#handle_attr_writer  4.3
    lib/zombie_scout/parser.rb:89   ZombieScout::Parser#handle_def_delegator        3.8
    lib/zombie_scout/parser.rb:95   ZombieScout::Parser#handle_scope        3.8
    lib/zombie_scout/parser.rb:122  ZombieScout::ConstExtracter#on_const    2.7
    lib/zombie_scout/parser.rb:116  ZombieScout::SymbolExtracter#on_sym     2.4

(See what I meant about callbacks and false-positives?)

Or you can run it on a given file or glob:

    dan@aleph:~/projects/zombie_scout$ zombie_scout scout lib/app.rb
    Scouted 1 methods in 1 files, in 0.041942649 seconds.
    Found 0 potential zombies, with a combined flog score of 0.0.

ZombieScout will also report in CSV, if you like:

    dan@aleph:~/projects/zombie_scout$ zombie_scout scout --format csv
    location,name,flog_score
    lib/zombie_scout/parser.rb:45,ZombieScout::Parser#on_send,8.3
    lib/zombie_scout/parser.rb:17,ZombieScout::Parser#on_class,7.9
    lib/zombie_scout/parser.rb:25,ZombieScout::Parser#on_module,7.2
    lib/zombie_scout/parser.rb:39,ZombieScout::Parser#on_defs,5.9
    lib/zombie_scout/parser.rb:81,ZombieScout::Parser#handle_def_delegators,5.8
    lib/zombie_scout/parser.rb:72,ZombieScout::Parser#handle_attr_accessor,5.6
    lib/zombie_scout/parser.rb:33,ZombieScout::Parser#on_def,4.9
    lib/zombie_scout/parser.rb:56,ZombieScout::Parser#handle_attr_reader,4.3
    lib/zombie_scout/parser.rb:64,ZombieScout::Parser#handle_attr_writer,4.3
    lib/zombie_scout/parser.rb:89,ZombieScout::Parser#handle_def_delegator,3.8
    lib/zombie_scout/parser.rb:95,ZombieScout::Parser#handle_scope,3.8
    lib/zombie_scout/parser.rb:122,ZombieScout::ConstExtracter#on_const,2.7
    lib/zombie_scout/parser.rb:116,ZombieScout::SymbolExtracter#on_sym,2.4

### In Ruby

You can also embed ZombieScout in your own code, if you need that kind of
thing:

    irb> require 'zombie_scout'
     => true
    irb> require 'pp'
     => true
    irb> > pp ZombieScout::Mission.new('.').scout
    [{:location=>"./lib/zombie_scout/parser.rb:17",
      :file_path=>"./lib/zombie_scout/parser.rb",
      :name=>:on_class,
      :full_name=>"ZombieScout::Parser#on_class",
      :flog_score=>7.9},
     {:location=>"./lib/zombie_scout/parser.rb:25",
      :file_path=>"./lib/zombie_scout/parser.rb",
      :name=>:on_module,
      :full_name=>"ZombieScout::Parser#on_module",
      :flog_score=>7.2},
     {:location=>"./lib/zombie_scout/parser.rb:33",
      :file_path=>"./lib/zombie_scout/parser.rb",
      :name=>:on_def,
      :full_name=>"ZombieScout::Parser#on_def",
      :flog_score=>4.9}, ...]

## Code Status

* [![Build Status](https://travis-ci.org/danbernier/zombie_scout.png?branch=master)](https://travis-ci.org/danbernier/zombie_scout)
* [![Code Climate](https://codeclimate.com/github/danbernier/zombie_scout.png)](https://codeclimate.com/github/danbernier/zombie_scout)

## TODOs

* [x] parse for attr_reader/writer/accessors, & forwardables, & rails scopes
* [ ] parse for rails delegators
* [ ] let users configure: files to search for methods, files to search for calls...probably in `.zombie_scout`.
* [x] option for CSV output
* [ ] if 2 classes have a method w/ the same name, you can't tell (right now, easily) whether it's dead - so don't grep for it.
* [ ] look for db/schema.rb & db/structure.sql, parse out columns, & look for those.

ToThinkAbouts:
* [x] extract a hash-y report structure that can be used by whatever, from the default report
* [x] pass a ruby file, or a glob
* [ ] rspec/mini-test drop-in tests that can be added easily, to fail your
  build if the scout or spy finds dead code. (This is probably a bad idea.)

Have ZombieScout make a hash-y report, & feed it to ZombieSpy, so the Spy knows where to focus.


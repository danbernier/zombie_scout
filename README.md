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

Then it greps your whole project - currently *.rb and *.erb files - for
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
    Scouted 43 methods in 9 files, in 1.096459054 seconds.
    Found 11 potential zombies, with a combined flog score of 51.5.

    lib/zombie_scout/parser.rb:29   on_send 8.3
    lib/zombie_scout/parser.rb:23   on_defs 5.9
    lib/zombie_scout/parser.rb:65   handle_def_delegators   5.8
    lib/zombie_scout/parser.rb:56   handle_attr_accessor    5.6
    lib/zombie_scout/parser.rb:17   on_def  4.9
    lib/zombie_scout/parser.rb:48   handle_attr_writer      4.3
    lib/zombie_scout/parser.rb:40   handle_attr_reader      4.3
    lib/zombie_scout/parser.rb:73   handle_def_delegator    3.8
    lib/zombie_scout/parser.rb:79   handle_scope    3.8
    lib/zombie_scout/parser.rb:100  on_sym  2.4
    lib/zombie_scout/mission.rb:34  zombie_count    2.4

(See what I meant about callbacks and false-positives?)

Or you can run it on a given file or glob:

    dan@aleph:~/projects/zombie_scout$ zombie_scout scout lib/app.rb
    Scouted 1 methods in 1 files, in 0.041942649 seconds.
    Found 0 potential zombies, with a combined flog score of 0.0.

ZombieScout will also report in CSV, if you like:

    dan@aleph:~/projects/zombie_scout$ zombie_scout scout --format csv
    location,name,flog_score
    lib/zombie_scout/parser.rb:29,on_send,8.3
    lib/zombie_scout/parser.rb:23,on_defs,5.9
    lib/zombie_scout/parser.rb:65,handle_def_delegators,5.8
    lib/zombie_scout/parser.rb:56,handle_attr_accessor,5.6
    lib/zombie_scout/parser.rb:17,on_def,4.9
    lib/zombie_scout/parser.rb:48,handle_attr_writer,4.3
    lib/zombie_scout/parser.rb:40,handle_attr_reader,4.3
    lib/zombie_scout/parser.rb:73,handle_def_delegator,3.8
    lib/zombie_scout/parser.rb:79,handle_scope,3.8
    lib/zombie_scout/parser.rb:100,on_sym,2.4
    lib/zombie_scout/mission.rb:34,zombie_count,2.4

### In Ruby

You can also embed ZombieScout in your own code, if you need that kind of
thing:

    irb> require 'zombie_scout'
     => true
    irb> require 'pp'
     => true
    irb> > pp ZombieScout::Mission.new('.').scout
    [{:location=>"./lib/zombie_scout/parser.rb:17",
      :name=>:on_def,
      :flog_score=>4.9},
     {:location=>"./lib/zombie_scout/parser.rb:23",
      :name=>:on_defs,
      :flog_score=>5.9},
     {:location=>"./lib/zombie_scout/parser.rb:29",
      :name=>:on_send,
      :flog_score=>8.3}, ...]

## Code Status

* [![Build Status](https://travis-ci.org/danbernier/zombie_scout.png?branch=master)](https://travis-ci.org/danbernier/zombie_scout)

## TODOs

* [x] parse for attr_reader/writer/accessors, & forwardables, & rails scopes
* [ ] parse for rails delegators
* [ ] let users configure: files to search for methods, files to search for calls...probably in `.zombie_scout`.
* [x] option for CSV output

ToThinkAbouts:
* [x] extract a hash-y report structure that can be used by whatever, from the default report
* [x] pass a ruby file, or a glob
* [ ] rspec/mini-test drop-in tests that can be added easily, to fail your
  build if the scout or spy finds dead code. (This is probably a bad idea.)

Have ZombieScout make a hash-y report, & feed it to ZombieSpy, so the Spy knows where to focus.


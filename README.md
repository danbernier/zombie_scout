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

### Fair Warning

Zombie Scout isn't exhaustive or thorough - it's a scout, not a spy. (That
could be another project, though - a Zombie Spy.)

If you generate methods in a way that's hard to grep for...

    method_name = ['s', 'e', 'c', 'r', 'e', 't']
    object.send(method_name.join(''))

...then Zombie Scout won't find it. Remember: light & quick.

That said, it *will* find methods defined with `attr_reader` & friends, or
`Forwardable` delegates.  Rails scopes & delegators are on the To-Do list.

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

It's super-early! But if you don't mind living with a few bugs, add this to
your Gemfile:

    gem 'zombie_scout', github: 'danbernier/zombie_scout'

I'll push to rubygems soon.

## Usage

You can run it on a whole folder:

    dan@aleph:~/projects/zombie_scout$ zombie_scout scout
    Scouting out /home/dan/projects/zombie_scout!
    lib/zombie_scout/method_finder.rb:23    on_def
    lib/zombie_scout/method_finder.rb:29    on_defs
    lib/zombie_scout/method_finder.rb:35    on_send
    lib/zombie_scout/method_finder.rb:77    on_sym
    Scouted 23 methods in 8 files. Found 4 potential zombies.

(See what I meant about callbacks and false-positives?)

Or you can run it on a given file or glob:

    dan@aleph:~/projects/zombie_scout$ zombie_scout scout lib/zombie_scout.rb
    Scouting out /home/dan/projects/zombie_scout!
    Scouted 0 methods in 1 files. Found 0 potential zombies.

## Code Status

* [![Build Status](https://travis-ci.org/danbernier/zombie_scout.png?branch=master)](https://travis-ci.org/danbernier/zombie_scout)

## TODOs

* [x] switch from rake tasks to Thor app
* [x] change to parser gem: http://rubygems.org/gems/parser
* [x] parse for attr_reader/writer/accessors, & forwardables
* [ ] parse for rails scopes & delegators
* [ ] let users configure: files to search for methods, files to search for calls...probably in `.zombie_scout`.
* [x] make sure you're searching right for `def foo=(val)` methods

ToThinkAbouts:
* [ ] extract a hash-y report structure that can be used by whatever, from the default report
* [ ] pass a method name, or a ruby class
* [ ] rspec/mini-test drop-in tests that can be added easily, to fail your
  build if the scout or spy finds dead code. (This is probably a bad idea.)

Have ZombieScout make a hash-y report, & feed it to ZombieSpy, so the Spy knows where to focus.


zombie_scout
=============

Find dead methods in your Rails app

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
could be another project, though - a Zombie Spy.) If you generate methods in a
way that's hard to grep for...

    method_name = ['s', 'e', 'c', 'r', 'e', 't']
    object.send(method_name.join(''))

...then Zombie Scout won't find it. Remember: light & quick.

This also means it can't find methods defined with `attr_reader` & friends, or
Rails scopes, or `Forwardable` methods, or Rails delegators. But those are
common situations, so they're on the To-do list.

If you have methods that are used by another library - say, callbacks - Zombie
Scout will probably think they're dead, because it's not looking at the source
for that other library. Be wise.

### Current Status

This is so alpha, it's almost omega.

The code is being extracted from a one-off script I used to run, and basically
re-written at the same time. It's changing from a rake task to a Thor app, and
when I'm done, it should work on *any* ruby codebase, not just a rails app.

It's undocumented. (TODO write some docs.)

It's not exactly well-spec'd, but that one-off script has found many dead
methods in a real code base. But like I said, I'm basically re-writing it.

Long story short, don't bet your bonus on this just yet.

## Installation

It's super-early! But if you don't mind living with a few bugs:

    gem install zombie_scout

Or add this to your Gemfile:

    gem 'zombie_scout', github: 'danbernier/zombie_scout'

## Usage

TODO, but will basically be `$ zombie_scout scout`

## TODOs

* [x] switch from rake tasks to Thor app
* [x] change to parser gem: http://rubygems.org/gems/parser
* [ ] parse for attr_reader/writer/accessors, scopes, forwardables, and delegators.
* [ ] let users configure: files to search for methods, files to search for calls...probably in `.zombie_scout`.
* [ ] make sure you're searching right for `def foo=(val)` methods

ToThinkAbouts:
* [ ] extract a hash-y report structure that can be used by whatever, from the default report
* [ ] pass a method name, or a ruby class
* [ ] rspec/mini-test drop-in tests that can be added easily, to fail your
  build if the scout or spy finds dead code. (This is probably a bad idea.)

Have ZombieScout make a hash-y report, & feed it to ZombieSpy, so the Spy knows where to focus.


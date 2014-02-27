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

This also means it can't find methods defined with ~~`attr_reader` & friends, or~~
Rails scopes, ~~or `Forwardable` methods,~~ or Rails delegators. But those are
common situations, so they're on the To-do list.

If you have methods that are used by another library - say, callbacks - Zombie
Scout will probably think they're dead, because it's not looking at the source
for that other library.

Finally, if you have a method named after a common human-language word, and
that word appears in (say) hard-coded strings or comments, Zombie Scout will
think it's calling the method, and assume that the method is used.

Be wise.

## Installation

It's super-early! But if you don't mind living with a few bugs, add this to
your Gemfile:

    gem 'zombie_scout', github: 'danbernier/zombie_scout'

I'll push to rubygems soon.

## Usage

TODO, but will basically be `$ zombie_scout scout`

## TODOs

* [x] switch from rake tasks to Thor app
* [x] change to parser gem: http://rubygems.org/gems/parser
* [ ] parse for attr_reader/writer/accessors, scopes, forwardables, and delegators.
* [ ] let users configure: files to search for methods, files to search for calls...probably in `.zombie_scout`.
* [x] make sure you're searching right for `def foo=(val)` methods

ToThinkAbouts:
* [ ] extract a hash-y report structure that can be used by whatever, from the default report
* [ ] pass a method name, or a ruby class
* [ ] rspec/mini-test drop-in tests that can be added easily, to fail your
  build if the scout or spy finds dead code. (This is probably a bad idea.)

Have ZombieScout make a hash-y report, & feed it to ZombieSpy, so the Spy knows where to focus.


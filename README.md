zombie_scout
=============

Find dead methods in your Rails app

Zombie Scout is light & quick. Its only tools are `ruby_parser` and `grep`.

It parses your code, finds method declarations, and then greps through your
project's source, looking for that method.  If it can't find the method name
anywhere, it presumes the method is dead, and reports back to you.

Zombie Scout isn't exhaustive or thorough - it's a scout, not a spy. (That
could be another project, though - a Zombie Spy.) If you generate methods in a
way that's hard to grep for...

    method_name = ['s', 'e', 'c', 'r', 'e', 't']
    object.send(method_name.join(''))

...then Zombie Scout won't find it. Remember: light & quick.

## Current Status

This is so alpha, it's almost omega.

The code is being extracted from a one-off script I used to run, and basically
re-written at the same time. It's changing from a rake task to a Thor app, and
when I'm done, it should work on *any* ruby codebase, not just a rails app.

It's undocumented. (TODO write some docs.)

It's not exactly well-spec'd, but that one-off script has found many dead
methods in a real code base. But like I said, I'm basically re-writing it.

Long story short, don't bet your bonus on this just yet.

## TODOs

- [x] switch from rake tasks to Thor app
- [ ] version.rb
- [ ] change to parser gem: http://rubygems.org/gems/parser
- [ ] parse for attr_reader/writer/accessors, scopes, forwardables, and delegators.
- [ ] let users configure: files to search for methods, files to search for calls...

ToThinkAbouts:
- [ ] extract a hash-y report structure that can be used by whatever, from the default report
- [ ] a "search for usages in specs" option
- [ ] pass a method name, or a ruby class
- [ ] rspec/mini-test drop-in tests that can be added easily, to fail your
  build if the scout or spy finds dead code. (This is probably a bad idea.)

Have ZombieScout make a hash-y report, & feed it to ZombieSpy, so the Spy knows where to focus.


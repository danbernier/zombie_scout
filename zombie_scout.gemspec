# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zombie_scout/version'

Gem::Specification.new do |s|
  s.name        = 'zombie_scout'
  s.version     = ZombieScout::VERSION
  s.date        = Date.today.to_s

  s.summary     = "Find dead methods in your Ruby app"
  s.description = "
      zombie_scout finds methods in classes in your ruby project,
      and then searches for calls to them, and tells you which ones
      are never called.".strip.gsub(/^\s*/, '')
  s.homepage    = 'https://github.com/danbernier/zombie_scout'
  s.license     = 'ASL2'

  s.authors     = ["Dan Bernier"]
  s.email       = ['danbernier@gmail.com']

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_dependency('parser', '~> 2.1')
  s.add_dependency('thor', '~> 0.18')
  s.add_dependency('flog', '~> 4.2')
  s.add_development_dependency "bundler", "~> 1.5"
end

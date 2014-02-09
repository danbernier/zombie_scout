Gem::Specification.new do |s|
  s.name        = 'zombie_scout'
  s.version     = '0.0.1'
  s.date        = '2014-02-07'
  s.summary     = "Find dead methods in your Rails app"
  s.description = "
      zombie_scout finds methods in classes in your ruby project, 
      and then searches for calls to them, and tells you which ones 
      are never called.".strip.gsub(/^\s*/, '')
  s.authors     = ["Dan Bernier"]
  s.email       = 'danbernier@gmail.com'
  s.files       = ['Rakefile'] + Dir.glob("lib/*.rb")
  s.homepage    = 'http://rubygems.org/gems/zombie_scout'
  s.license     = 'ASL2'

  s.add_dependency('ruby_parser', '=3.0.0.a9')
  s.add_dependency('thor', '~> 0.18')
end

You basically want to parse all ruby files in a folder.
(Or, parse the ONE ruby file they want.)

And then, for ALL files in that folder,
(but how do you know which folder, if they specified a full file path? just assume .?)
grep for methods you found in the ruby sources.
(or in the one ruby source they specified.)


      -----------             -----------
      | ruby    |-----------> | ruby    |
      | sources |             | methods |
      -----------             -----------




      .     ->  ./{app,lib}/**/*.rb  ->  methods  ->  grep in ./**/*.{rb,erb}

      File  -------------------------->  methods  ->  grep in ./**/*.{rb,erb}

      dir-names  -> DIR-NAME/**/*.rb ->  methods  ->  grep in ./**/*.{rb,erb}
      
      file-names --------------------->  methods  ->  grep in ./**/*.{rb,erb}
      
      globs -------------------------->  methods  ->  grep in ./**/*.{rb,erb} 






# Notes on Gemspecs

http://guides.rubygems.org/specification-reference/
Write your gemspec yourself: http://jeffkreeftmeijer.com/2010/be-awesome-write-your-gemspec-yourself/
Dev'ing a gem w/ Bundler: https://github.com/radar/guides/blob/master/gem-development.md



# Other useful links

Ben's MAID: https://github.com/benjaminoakes/maid/blob/master/lib/maid/app.rb
OptionParser: http://ruby-doc.org/stdlib-2.1.0/libdoc/optparse/rdoc/OptionParser.html

Maybe a good example, rubocop: https://github.com/bbatsov/rubocop

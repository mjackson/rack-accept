Gem::Specification.new do |s|
  s.name = 'rack-accept'
  s.version = '0.1.1'
  s.date = '2010-04-01'

  s.summary = 'HTTP Accept* for Ruby/Rack'
  s.description = 'HTTP Accept, Accept-Charset, Accept-Encoding, and Accept-Language for Ruby/Rack'

  s.author = 'Michael J. I. Jackson'
  s.email = 'mjijackson@gmail.com'

  s.require_paths = %w< lib >

  s.files = Dir['lib/**/*.rb'] +
    Dir['test/*.rb'] +
    Dir['doc/**/*'] +
    %w< CHANGES .gemspec Rakefile README >

  s.test_files = s.files.select {|path| path =~ /^test\/.*_test.rb/ }

  s.add_dependency('rack', '>= 0.4')
  s.add_development_dependency 'rake'

  s.has_rdoc = true
  s.rdoc_options = %w< --line-numbers --inline-source --title Rack::Accept --main Rack::Accept >
  s.extra_rdoc_files = %w< CHANGES README >

  s.homepage = 'http://github.com/mjijackson/rack-accept'
end

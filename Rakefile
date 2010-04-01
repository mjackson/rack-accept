require 'rake/clean'
require 'rake/testtask'

task :default => :test

CLEAN.include %w< doc/api >
CLOBBER.include %w< dist >

# TESTS #######################################################################

Rake::TestTask.new(:test) do |t|
  t.test_files = FileList['test/*_test.rb']
end

# DOCS ########################################################################

desc "Generate all documentation"
task :doc => %w< doc:api doc:etc >

namespace :doc do

  desc "Generate API documentation"
  task :api do
  end

  desc "Generate extra documentation"
  task :etc do
  end

end

# PACKAGING ###################################################################

if defined?(Gem)
  $spec = eval("$SAFE=1\n#{File.read('rack-accept.gemspec')}")

  def package(ext='')
    "dist/rack-accept-#{$spec.version}" + ext
  end

  desc "Build packages"
  task :package => %w< .gem .tar.gz >.map {|e| package(e) }

  desc "Build and install as local gem"
  task :install => package('.gem') do
    sh "gem install #{package('.gem')}"
  end

  directory 'dist/'

  file package('.gem') => %w< dist/ rack-accept.gemspec > + $spec.files do |f|
    sh "gem build rack-accept.gemspec"
    mv File.basename(f.name), f.name
  end

  file package('.tar.gz') => %w< dist/ > + $spec.files do |f|
    sh "git archive --format=tar HEAD | gzip > #{f.name}"
  end

  desc "Upload gem to rubygems.org"
  task :release => package('.gem') do |t|
    sh "gem push #{package('.gem')}"
  end
end

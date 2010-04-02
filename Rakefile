require 'rake/clean'
require 'rake/testtask'

task :default => :test

#CLEAN.include %w< doc/api >
CLOBBER.include %w< dist >

# TESTS #######################################################################

Rake::TestTask.new(:test) do |t|
  t.test_files = FileList['test/*_test.rb']
end

# DOCS ########################################################################

desc "Generate all documentation"
task :doc => %w< doc:api doc:etc >

namespace :doc do

  desc "Generate API documentation (in doc/api)"
  task :api => FileList['lib/**/*.rb'] do |t|
    rm_rf 'doc/api'
    sh((<<-SH).gsub(/[\s\n]+/, ' ').strip)
    hanna
      --op doc/api
      --promiscuous
      --charset utf8
      --fmt html
      --inline-source
      --line-numbers
      --accessor option_accessor=RW
      --main Rack::Accept
      --title 'Rack::Accept API Documentation'
      #{t.prerequisites.join(' ')}
    SH
  end

  desc "Generate extra documentation"
  task :etc do
  end

end

# PACKAGING ###################################################################

if defined?(Gem)
  $spec = eval("#{File.read('.gemspec')}")

  directory 'dist'

  def package(ext='')
    "dist/rack-accept-#{$spec.version}" + ext
  end

  desc "Build packages"
  task :package => %w< .gem .tar.gz >.map {|e| package(e) }

  desc "Build and install as local gem"
  task :install => package('.gem') do
    sh "gem install #{package('.gem')}"
  end

  file package('.gem') => %w< dist > + $spec.files do |f|
    sh "gem build .gemspec"
    mv File.basename(f.name), f.name
  end

  file package('.tar.gz') => %w< dist > + $spec.files do |f|
    sh "git archive --format=tar HEAD | gzip > #{f.name}"
  end

  desc "Upload gem to rubygems.org"
  task :release => package('.gem') do |t|
    sh "gem push #{package('.gem')}"
  end
end

require 'rake/clean'
require 'rake/testtask'

task :default => :test

CLEAN.include %w< doc/api doc/*.html doc/*.css >
CLOBBER.include %w< dist >

# TESTS #######################################################################

Rake::TestTask.new(:test) do |t|
  t.test_files = FileList['test/*_test.rb']
end

# DOCS ########################################################################

desc "Generate HTML documentation (in doc)"
task :doc => FileList['doc/*.markdown'] do |t|
  require 'erb' unless defined?(ERB)
  require 'rdiscount' unless defined?(RDiscount)
  layout = ERB.new(File.read('doc/assets/layout.html.erb'), 0, '%<>')
  t.prerequisites.each do |path|
    source = File.read(path)
    content = Markdown.new(source, :smart).to_html
    output = layout.result(binding)
    File.open(path.sub('.markdown', '.html'), 'w') {|io| io.write(output) }
  end
  cp 'doc/assets/style.css', 'doc'
end

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

# PACKAGING & INSTALLATION ####################################################

if defined?(Gem)
  $spec = eval("#{File.read('.gemspec')}")

  directory 'dist'

  def package(ext='')
    "dist/rack-accept-#{$spec.version}" + ext
  end

  file package('.gem') => %w< dist > + $spec.files do |f|
    sh "gem build .gemspec"
    mv File.basename(f.name), f.name
  end

  file package('.tar.gz') => %w< dist > + $spec.files do |f|
    sh "git archive --format=tar HEAD | gzip > #{f.name}"
  end

  desc "Build packages"
  task :package => %w< .gem .tar.gz >.map {|e| package(e) }

  desc "Build and install as local gem"
  task :install => package('.gem') do |t|
    sh "gem install #{package('.gem')}"
  end

  desc "Upload gem to rubygems.org"
  task :release => package('.gem') do |t|
    sh "gem push #{package('.gem')}"
  end
end

# check for RSpec plugin
rspec_path = File.join(%W(#{File.dirname(__FILE__)} .. rspec lib))
$:.unshift(rspec_path) if File.exists?(rspec_path) && !$:.include?(rspec_path)

require 'rake'
require 'rake/rdoctask'
require 'spec/rake/spectask'

desc 'Default: run the specs.'
task :default => :spec

desc 'Run the specs for the germinate plugin.'
Spec::Rake::SpecTask.new(:spec) do |t|
  options_path = File.join(%W(#{File.dirname(__FILE__)} spec spec.opts))
  t.spec_opts = ['--options', %("#{options_path}")]
  t.spec_files = FileList['spec/**/*_spec.rb']
end

desc 'Generate documentation for the germinate plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Germinate'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

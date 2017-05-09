require 'pry'

def lib_and_spec_paths
  filename = ARGV[1]
  project_root = __FILE__.gsub(/\/Rakefile\z/, '')

  lib_path = File.join(project_root, "lib/#{filename}.rb")
  spec_path = File.join(project_root, "spec/#{filename}_spec.rb")
  [lib_path, spec_path]
end

task :default do
  ARGV.each do |t|
    task t.to_sym {}
  end
end

task :generate => :default do
  lib_and_spec_paths.each { |p| `touch #{p}` }
end

task :remove => :default do
  lib_and_spec_paths.each { |p| `rm #{p}` }
end

require 'pry'

lib_files = Dir.glob('lib/*.rb')
lib_file_paths = lib_files.map { |f| File.join(__FILE__, "../../../#{f}") }
lib_file_paths.each { |file| require_relative file }

def app_root
  __FILE__.gsub(/\/spec\/support\/spec_helper\.rb\z/, '')
end


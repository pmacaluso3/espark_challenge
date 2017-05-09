require 'pry'

def app_root
  __FILE__.gsub(/\/spec\/support\/spec_helper\.rb\z/, '')
end

lib_files = Dir.glob("#{app_root}/lib/*.rb")
lib_files.each { |f| require f }

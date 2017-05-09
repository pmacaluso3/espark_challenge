require 'pry'

def app_root
  File.expand_path('../../..', __FILE__)
end

lib_files = Dir.glob("#{app_root}/lib/*.rb")
lib_files.each { |f| require f }

require 'pry'

def project_root
  File.expand_path('..', __FILE__)
end

def lib_and_spec_paths
  filename = ARGV[1]
  lib_path = File.join(project_root, "lib/#{filename}.rb")
  spec_path = File.join(project_root, "spec/#{filename}_spec.rb")
  [lib_path, spec_path]
end

task :allow_argv do
  ARGV.each { |t|task t.to_sym {} }
end

task :environment do
  lib_files = Dir.glob("#{project_root}/lib/*.rb")
  lib_files.each { |f| require f }
end

namespace :file do
  task :generate => :allow_argv do
    lib_and_spec_paths.each { |p| `touch #{p}` }
  end

  task :remove => :allow_argv do
    lib_and_spec_paths.each { |p| `rm #{p}` }
  end
end

desc 'make_learning_paths [<output_filename>], [<student_tests_input_filename>], [<domain_order_input_filename>]'
task :make_learning_paths => [:allow_argv, :environment] do
  output_filename = ARGV[1] || 'learning_paths.csv'
  output_filepath = File.join(project_root, "data/#{output_filename}")

  student_tests_filename, domain_order_filename = ARGV[2], ARGV[3]

  learning_paths = LearningPathManager.new(student_tests_filename, domain_order_filename).learning_paths

  File.open(output_filepath, 'w') do |f|
    learning_paths.each { |lp| f.write("#{lp}\n") }
  end
end

desc 'sample_test [<test_output_filename>], [<data_to_test>], [<given_sample_data>], '
task :sample_test => [:allow_argv, :environment] do
  test_output_filename = ARGV[1] || 'test_output.txt'
  data_to_test_filename = ARGV[2] || 'learning_paths.csv'
  sample_data_filename = ARGV[3] || 'sample_solution.csv'

  test_output_filepath = File.join(project_root, "data/#{test_output_filename}")
  data_to_test_filepath = File.join(project_root, "data/#{data_to_test_filename}")
  sample_data_filepath = File.join(project_root, "data/#{sample_data_filename}")

  data_to_test = File.read(data_to_test_filepath).split("\n")
  sample_data = File.read(sample_data_filepath).split("\n")

  File.open(test_output_filepath, 'w') do |f|
    data_to_test.each_with_index do |test_datum, line_num|
      if test_datum != sample_data[line_num]
        report_string = "Expected: #{sample_data[line_num]}\nGot:      #{test_datum}\n\n"
        f.write(report_string)
      end
    end
  end
end

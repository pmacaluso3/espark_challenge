require_relative 'support/spec_helper'

describe LearningPathManager do
  let(:student_tests_filename) { app_root + '/spec/data/student_tests.csv' }
  let(:domain_order_filename) { app_root + '/spec/data/domain_order.csv' }
  let(:learning_path_manager) { described_class.new(student_tests_filename, domain_order_filename) }

  describe '#learning_paths' do
    it 'returns an array of strings' do
      expect(learning_path_manager.learning_paths).to be_a Array
      expect(learning_path_manager.learning_paths.first).to be_a String
    end
  end
end

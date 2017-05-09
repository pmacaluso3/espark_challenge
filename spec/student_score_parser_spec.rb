require_relative 'support/spec_helper'

describe StudentScoreParser do
  describe '::parse' do
    let(:header_row) { "Student Name,RF,RL,RI,L\n" }
    let(:student_row) { "Albin Stanton,2,3,K,3\n" }
    let(:test_filename) { app_root + '/spec/data/student_tests.csv' }
    let(:student_scores) { StudentScoreParser.parse(test_filename) }

    def reset_test_csv(filename)
      File.open(filename, 'w') do |f|
        f.write header_row
        f.write student_row
      end
    end

    before(:each) do
      reset_test_csv(test_filename)
    end

    it 'returns an array of StudentScore objects' do
      expect(student_scores).to be_a(Array)
      expect(student_scores.first).to be_a(StudentScore)
    end
  end
end

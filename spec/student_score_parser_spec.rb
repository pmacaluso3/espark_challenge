require_relative 'support/spec_helper'

describe StudentScoreParser do
  describe '::sanitize_key' do
    it 'converts keys to symbols' do
      expect(StudentScoreParser.sanitize_key('key')).to be_a(Symbol)
    end

    it 'downcases capitalized keys' do
      expect(StudentScoreParser.sanitize_key('RF')).to eq(:rf)
    end

    it 'removes replaces spaces in keys with underscores' do
      expect(StudentScoreParser.sanitize_key('Student Name')).to eq(:student_name)
    end
  end

  describe '::parse' do
    let(:header_row) { "Student Name,RF,RL,RI,L\n" }
    let(:header_keys) do
      header_row.chomp.split(',').map { |k| StudentScoreParser.sanitize_key(k) }
    end
    let(:student_row) { "Albin Stanton,2,3,K,3\n" }
    let(:student_values) { student_row.chomp.split(',') }
    let(:student_scores) { StudentScoreParser.parse(test_filename) }
    let(:test_filename) { app_root + '/spec/data/student_tests.csv' }

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

    it 'assigns values to each header' do
      header_keys.each_with_index do |key, i|
        expect(student_scores.first[key]).to eq(student_values[i])
      end
    end
  end

end

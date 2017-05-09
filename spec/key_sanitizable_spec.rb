require_relative 'support/spec_helper'

describe KeySanitizable do
  let(:dummy_class) { Class.new { include KeySanitizable } }
  let(:dummy_instance) { dummy_class.new }

  describe '#sanitize_key' do
    it 'converts keys to symbols' do
      expect(dummy_instance.sanitize_key('key')).to be_a(Symbol)
    end

    it 'downcases capitalized keys' do
      expect(dummy_instance.sanitize_key('RF')).to eq(:rf)
    end

    it 'removes replaces spaces in keys with underscores' do
      expect(dummy_instance.sanitize_key('Student Name')).to eq(:student_name)
    end
  end

  describe '#convert_non_numeric_score' do
    describe 'when score string represents a number' do
      it 'converts it to that number' do
        expect(dummy_instance.convert_non_numeric_score('1')).to eq(1)
      end
    end

    describe 'when score is a known non-numeric score such as K' do
      it 'converts it to the equivalent numeric score according to its dictionary' do
          expect(dummy_instance.convert_non_numeric_score('K')).to eq(0)
      end
    end
  end
end

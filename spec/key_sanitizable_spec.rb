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
end

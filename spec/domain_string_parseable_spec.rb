require_relative 'support/spec_helper'

describe DomainStringParseable do
  let(:dummy_class) { Class.new { include DomainStringParseable } }
  let(:dummy_instance) { dummy_class.new }
  let(:dom_str) { '1.rl' }

  describe '#parse_domain_string' do
    it 'generates a number for the grade level in the first position' do
      expect(dummy_instance.parse_domain_string(dom_str)[0]).to eq(1)
    end

    it 'generates a symbol for the domain in the second position' do
      expect(dummy_instance.parse_domain_string(dom_str)[1]).to eq(:rl)
    end
  end

  describe '#make_domain_string' do
    it 'makes a properly formatted domain string' do
      expect(dummy_instance.make_domain_string(:ri, 1)).to eq('1.ri')
    end
  end

  describe '#print_format' do
    it 'capitalizes the domain' do
      expect(dummy_instance.print_format('1.ri')).to eq('1.RI')
    end

    describe 'for grades with non-numeric equivalents' do
      it 'uses the non-numeric equivalent of that grade' do
        expect(dummy_instance.print_format('0.rf')).to eq('K.RF')
      end
    end

    describe 'for numeric grades' do
      it 'uses the number for that grade' do
        expect(dummy_instance.print_format('1.rf')).to eq('1.RF')
      end
    end
  end

end

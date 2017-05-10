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

end

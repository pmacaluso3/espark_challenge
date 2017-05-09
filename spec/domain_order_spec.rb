require_relative 'support/spec_helper'

describe DomainOrder do
  describe '#grades' do
    describe 'when args contained only numeric strings as keys' do
      let(:domain_order) do
        described_class.new({ "1"=>["RF"], "2"=>["RF"] })
      end

      it 'converts keys to numbers' do
        expect(domain_order.grades).to eq([1, 2])
      end
    end

    describe 'when args contained non-numeric keys' do
      let(:domain_order) do
        described_class.new({ "K"=>["RF"], "1"=>["RF"] })
      end

      it 'converts keys to their numeric equivalents' do
        expect(domain_order.grades).to eq([0, 1])
      end
    end
  end

  describe '#domains_for_grade' do
    let(:domain_order) do
      described_class.new({
        "1"=>["RF", "RL", "RI"],
        "2"=>["RF", "RI", "RL", "L"]
      })
    end

    it 'returns the sanitized version of the domains available at the specified grade' do
      expect(domain_order.domains_for_grade(1)).to eq([:rf, :rl, :ri])
      expect(domain_order.domains_for_grade(2)).to eq([:rf, :ri, :rl, :l])
    end
  end

  describe '#valid_domain?' do
    let(:domain_order) do
      described_class.new({
        "1"=>["RF", "RL", "RI"],
        "2"=>["RF", "RI", "RL", "L"]
      })
    end
    let(:valid_domain_string) { '1.ri' }
    let(:invalid_domain_string) { '1.l' }

    describe 'when a domain string is valid' do
      it 'returns true' do
        expect(domain_order.valid_domain?(valid_domain_string)).to be true
      end
    end

    describe 'when a domain string is invalid' do
      it 'returns false' do
        expect(domain_order.valid_domain?(invalid_domain_string)).to be false
      end
    end
  end

end

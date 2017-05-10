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
    let(:nonexistant_domain_string) { '1.l' }

    describe 'when a domain string is valid' do
      it 'returns true' do
        expect(domain_order.valid_domain?(valid_domain_string)).to be true
      end
    end

    describe 'when a domain string represents a nonexistant domain' do
      it 'returns false' do
        expect(domain_order.valid_domain?(nonexistant_domain_string)).to be false
      end
    end
  end

  describe '#finished?' do
    let(:domain_order) do
      described_class.new({
        '3' => ['RF', 'RL', 'RI', 'L'],
        '4' => ['RI', 'RL', 'L']
      })
    end

    describe 'when the current grade is the end of this domain track' do
      let(:terminal_domain_string) { '3.rf' }

      it 'returns true' do
        expect(domain_order.finished?(terminal_domain_string)).to be true
      end
    end

    describe 'when the given domain exists at the following grade' do
      let(:continuing_domain_string) { '3.ri' }

      it 'returns false' do
        expect(domain_order.finished?(continuing_domain_string)).to be false
      end
    end
  end

  describe '#lowest_grade_for_domain' do
    let(:domain_order) do
      described_class.new({
        '1'=>['RF', 'RL', 'RI'],
        '2'=>['RF', 'RI', 'RL', 'L']
      })
    end

    describe 'when the domain exists in at least one grade' do
      describe 'when the domain exists for the first available grade' do
        it 'returns that grade' do
          expect(domain_order.lowest_grade_for_domain(:rf)).to eq(1)
        end
      end

      describe 'when the domain does not exist for the first available grade' do
        it 'returns the lowest grade for which it exists' do
          expect(domain_order.lowest_grade_for_domain(:l)).to eq(2)
        end
      end
    end

    describe 'when the domain does not exist at all' do
      it 'returns nil' do
        expect(domain_order.lowest_grade_for_domain(:x)).to be nil
      end
    end
  end

  describe '#highest_grade_for_domain' do
    let(:domain_order) do
      described_class.new({
        '3' => ['RF', 'RL', 'RI', 'L'],
        '4' => ['RI', 'RL', 'L']
      })
    end

    describe 'when the domain exists in at least one grade' do
      describe 'when the domain exists for the first available grade' do
        it 'returns that grade' do
          expect(domain_order.highest_grade_for_domain(:l)).to eq(4)
        end
      end

      describe 'when the domain does not exist for the first available grade' do
        it 'returns the highest grade for which it exists' do
          expect(domain_order.highest_grade_for_domain(:rf)).to eq(3)
        end
      end
    end

    describe 'when the domain does not exist at all' do
      it 'returns nil' do
        expect(domain_order.lowest_grade_for_domain(:x)).to be nil
      end
    end
  end

  describe '#expanded_domains' do
    let(:domain_order) do
      described_class.new({
        '1'=>['RF', 'RL', 'RI'],
        '2'=>['RF', 'RI', 'RL', 'L']
      })
    end
    let(:expected_expansion) { ['1.rf', '1.rl', '1.ri', '2.rf', '2.ri', '2.rl', '2.l'] }

    it 'expands the domain order correctly' do
      expect(domain_order.expanded_domains).to eq(expected_expansion)
    end
  end
end

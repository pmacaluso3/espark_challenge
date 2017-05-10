require_relative 'support/spec_helper'

describe StudentScore do
  describe '#domains' do
    describe 'when args contained non-domain keys such as "Student Name"' do
      let(:student_score) do
        described_class.new({
          'Student Name' => 'Albin Stanton',
          'RF' => '2',
          'RL' => '3',
        })
      end

      it 'rejects non-domain keys' do
        student_score.domain_scores.keys.each do |key|
          expect(described_class::NON_DOMAIN_HEADERS.include?(key)).to be false
        end
      end

      it 'keeps domain keys' do
        expect(student_score.domain_scores.keys).to eq([:rf, :rl])
      end
    end

    describe 'when args contained only numeric grade levels' do
      let(:student_score) do
        described_class.new({ 'RF' => '2', 'RL' => '3' })
      end

      it 'contains numeric scores' do
        expect(student_score.domain_scores).to eq({rf: 2, rl: 3})
      end
    end

    describe 'when containing non-numeric grade levels such as K' do
      let(:student_score) do
        described_class.new({ 'RF' => 'K', 'RL' => '3' })
      end

      it 'converts them to their numeric equivalents' do
        expect(student_score.domain_scores).to eq({rf: 0, rl: 3})
      end
    end
  end

  describe 'advance_domain!' do
    let(:student_score) do
      described_class.new({ 'RF' => '2', 'RL' => '3' })
    end

    describe 'when trying to advance a domain that the student is not on' do
      let(:invalid_domain_string) { '5.rl' }
      it 'raises an InvalidDomainError' do
        expect{ student_score.advance_domain!(invalid_domain_string) }.to raise_error(described_class::InvalidDomainError)
      end
    end

    describe 'when advancing a domain the student is on' do
      let(:dom_str) { '2.rf' }

      it 'increments the score for the given domain by 1' do
        expect{ student_score.advance_domain!(dom_str) }
          .to change{ student_score.rf }
          .by(1)
      end

      it 'returns the newly advanced domain' do
        expect(student_score.advance_domain!(dom_str)).to eq('2.rf')
      end
    end
  end

  describe '#complete_domain!' do
    let(:student_score) do
      described_class.new({ 'RI' => '2', 'RL' => '3' })
    end

    describe 'when trying to complete a domain that the student is not on' do
      let(:invalid_domain_string) { '5.rl' }
      it 'raises an InvalidDomainError' do
        expect{ student_score.complete_domain!(invalid_domain_string) }.to raise_error(described_class::InvalidDomainError)
      end
    end

    describe 'when completing a domain that the student is on' do
      let(:domain_to_complete) { '2.ri' }

      it 'sets the grade level for the domain to an arbitrarily high level' do
       student_score.complete_domain!(domain_to_complete)
       expect(student_score.ri).to eq(described_class::COMPLETION_SCORE)
      end
    end
  end

  describe '#any_domains_incomplete?' do
    let(:student_score) { described_class.new }

    describe 'when there are incomplete domains' do
      let(:incomplete_domain_scores) { { rf: described_class::COMPLETION_SCORE, l: 3 } }

      it 'returns true' do
        expect(student_score.any_domains_incomplete?(incomplete_domain_scores)).to be true
      end
    end

    describe 'when all domains have been completed' do
      let(:complete_domain_scores) { { rf: described_class::COMPLETION_SCORE, l: described_class::COMPLETION_SCORE } }

      it 'returns false' do
        expect(student_score.any_domains_incomplete?(complete_domain_scores)).to be false
      end
    end
  end
end

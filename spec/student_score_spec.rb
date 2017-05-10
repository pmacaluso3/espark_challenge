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
          expect(StudentScore::NON_DOMAIN_HEADERS.include?(key)).to be false
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

  describe '#weakest_domain' do
    describe 'when there is no tie for lowest' do
      let(:student_score) do
        described_class.new({ 'RF' => '3', 'RL' => '1' })
      end

      it 'returns the domain with the lowest score' do
        expect(student_score.weakest_domain).to eq('1.rl')
      end
    end

    describe 'when there is a tie for lowest' do
      let(:student_score) do
        described_class.new({ 'RF' => '3', 'RL' => '1', 'RI' => '1' })
      end

      it 'returns the first domain tied for lowest score' do
        expect(student_score.weakest_domain).to eq('1.rl')
      end
    end
  end

  describe 'advance_domain!' do
    let(:student_score) do
      described_class.new({ 'RF' => '2', 'RL' => '3' })
    end

    describe 'when given a valid domain string' do
      let(:valid_domain_string) { '2.rl' }

      it 'increments the score for the given domain by 1' do
        expect{ student_score.advance_domain!(valid_domain_string) }.to change{ student_score.rl }.by(1)
      end
    end

    describe 'when given just the name of a domain' do
      let(:invalid_domain_string) { '2.rl' }

      it 'increments the score for the given domain by 1' do
        expect{ student_score.advance_domain!(invalid_domain_string) }.to change{ student_score.rl }.by(1)
      end
    end
  end

  describe '#complete_domain!' do
    let(:student_score) do
      described_class.new({ 'RF' => '2', 'RL' => '3' })
    end

    describe 'when given a valid domain string' do
      let(:valid_domain_to_complete) { '2.rf' }

      it 'sets the grade level for the domain to an arbitrarily high level' do
       student_score.complete_domain!(valid_domain_to_complete)
       expect(student_score.rf).to eq(StudentScore::COMPLETION_SCORE)
      end
    end

    describe 'when given just the name of a domain' do
      let(:invalid_domain_to_complete) { 'rf' }

      it 'sets the grade level for the domain to an arbitrarily high level' do
       student_score.complete_domain!(invalid_domain_to_complete)
       expect(student_score.rf).to eq(StudentScore::COMPLETION_SCORE)
      end
    end
  end
end

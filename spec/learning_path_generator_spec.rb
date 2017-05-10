require_relative 'support/spec_helper'

describe LearningPathGenerator do
  let(:domain_order) do
    DomainOrder.new({
      'K' => ['RF', 'RL', 'RI'],
      '1' => ['RF', 'RL', 'RI'],
      '2' => ['RF', 'RI', 'RL', 'L'],
      '3' => ['RF', 'RL', 'RI', 'L'],
      '4' => ['RI', 'RL', 'L'],
      '5' => ['RI', 'RL', 'L'],
      '6' => ['RI', 'RL']
    })
  end
  let(:learning_path_generator) { described_class.new(student_score, domain_order) }

  describe '#next_unit' do
    describe 'when all domains are already complete' do
        let(:student_score) do
          StudentScore.new({
            'RF' => StudentScore::COMPLETION_SCORE,
            'RL' => StudentScore::COMPLETION_SCORE,
          })
        end

      it 'returns nil' do
        expect(learning_path_generator.next_unit).to be(nil)
      end
    end

    describe 'when there are incomplete domains' do
      describe 'and the weakest is not the last of its domain track' do
        let(:student_score) do
          StudentScore.new({
            'RF' => 'K',
            'RL' => '1',
          })
        end

        it 'advances the weakest domain within the student_score' do
          expect{ learning_path_generator.next_unit }
            .to change{ learning_path_generator.student_score.rf }
            .by(1)
        end

        it 'returns the newly advanced domain string for the learning path' do
          expect(learning_path_generator.next_unit).to eq('K.RF')
        end
      end

      describe 'and the weakest is the last of its domain track' do
        let(:student_score) do
          StudentScore.new({
            'RF' => '3',
            'RL' => '4',
          })
          # there is no 4.rf
        end

        it 'completes the terminal domain after advancing it' do
          expect{ learning_path_generator.next_unit }
            .to change{ learning_path_generator.student_score.rf }
            .to(StudentScore::COMPLETION_SCORE)
        end

        it 'returns the newly advanced domain string for the learning path' do
          expect(learning_path_generator.next_unit).to eq('3.RF')
        end
        # TODO: test the 2-to-3 RL/RI order switch
      end
    end
  end

  describe '#learning_path' do
    describe 'when the student has no scores' do
      let(:student_score) do
        StudentScore.new({
          'Student Name' => 'Albin Stanton',
          'RF' => '',
          'RL' => '',
          'RI' => '',
          'L' => ''
        })
      end
      let(:expected_learning_path) { 'Albin Stanton,K.RF,K.RL,K.RI,1.RF,1.RL' }

      it 'starts the student from the beginning' do
          expect(learning_path_generator.learning_path).to eq(expected_learning_path)
      end

    end

    describe 'when the student has scores' do
      describe 'and there are plenty of units left for the student' do
        let(:student_score) do
          StudentScore.new({
            'Student Name' => 'Albin Stanton',
            'RF' => '2',
            'RL' => '3',
            'RI' => 'K',
            'L' => '3'
          })
        end
        let(:expected_learning_path) { 'Albin Stanton,K.RI,1.RI,2.RF,2.RI,3.RF' }

        it 'generates a learning path consistent with the sample data' do
          expect(learning_path_generator.learning_path).to eq(expected_learning_path)
        end

      end

      describe 'but there are not enough units left' do
        let(:student_score) do
          StudentScore.new({
            'Student Name' => 'Albin Stanton',
            'RF' => '6',
            'RI' => '6',
            'RL' => '6',
            'L' => '6'
          })
        end
        let(:expected_learning_path) { 'Albin Stanton,6.RI,6.RL' }

        it 'assigns the student the remaining units and then quits' do
          expect(learning_path_generator.learning_path).to eq(expected_learning_path)
        end
      end
    end
  end
end

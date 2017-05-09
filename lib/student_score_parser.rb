require 'csv'

module StudentScoreParser
  STUDENT_TESTS_FILENAME = 'student_tests.csv'.freeze

  def self.parse(filename = STUDENT_TESTS_FILENAME)
    student_scores = []
    CSV.foreach(filename, headers: true) do |row|
      student_scores << StudentScore.new(row.to_hash)
    end
    student_scores
  end
end

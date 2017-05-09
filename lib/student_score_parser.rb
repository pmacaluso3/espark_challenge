require 'csv'

module StudentScoreParser
  STUDENT_TESTS_FILENAME = 'student_tests.csv'.freeze

  def self.parse(filename = STUDENT_TESTS_FILENAME)
    student_scores = []
    CSV.foreach(filename, headers: true) do |row|
      score = StudentScore.new
      row.each do |k, v|
        score.send("#{sanitize_key(k)}=", v)
      end
      student_scores << score
    end
    student_scores
  end

  def self.sanitize_key(key)
    key.downcase.gsub(' ', '_').to_sym
  end
end

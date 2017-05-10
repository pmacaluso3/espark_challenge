class LearningPathManager
  attr_reader :student_test_filename, :domain_order_filename

  def initialize(student_test_filename, domain_order_filename)
    @student_test_filename = student_test_filename
    @domain_order_filename = domain_order_filename
  end

  def student_scores
    @student_scores ||= if student_test_filename
      StudentScoreParser.parse(student_test_filename)
    else
      StudentScoreParser.parse
    end
  end

  def domain_order
    @domain_order ||= if domain_order_filename
      DomainOrderParser.parse(domain_order_filename)
    else
      DomainOrderParser.parse
    end
  end

  def learning_paths
    student_scores.map do |student_score|
      LearningPathGenerator.new(student_score, domain_order).learning_path
    end
  end
end

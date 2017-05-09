class LearningPathGenerator
  attr_reader :student_score, :domain_order

  def initialize(student_score, domain_order)
    @student_score = student_score
    @domain_order = domain_order
  end

  def next_unit
    loop do
      if domain_can_be_advanced?(weakest_domain)
        return advance_domain!(weakest_domain)
      else
        complete_domain!(weakest_domain)
      end
    end
  end

  def domain_can_be_advanced?(domain_string)
    domain_order.valid_domain_string?(weakest_domain)
  end

  private
  def weakest_domain
    student_score.weakest_domain
  end

  def method_name

  end
end

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

  private
  def weakest_domain
    student_score.weakest_domain
  end

  def domain_can_be_advanced?(dom_str)
    domain_order.domain_can_be_advanced?(dom_str)
  end

  def advance_domain!(dom_str)
    student_score.advance_domain!(dom_str)
  end

  def complete_domain!(dom_str)
    student_score.complete_domain!(dom_str)
  end
end

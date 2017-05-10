class LearningPathGenerator
  attr_reader :student_score, :domain_order

  UNITS_PER_LEARNING_PATH = 5

  include DomainStringParseable

  def initialize(student_score, domain_order)
    @student_score = student_score
    @domain_order = domain_order
  end

  def next_unit
    return nil unless any_domains_incomplete?
    completed_unit = weakest_domain
    if finished?(weakest_domain)
      complete_domain!(weakest_domain)
    else
      advance_domain!(weakest_domain)
    end
    print_format(completed_unit)
  end

  def learning_path
    path = [student_score.student_name]
    UNITS_PER_LEARNING_PATH.times do
      path << next_unit
    end
    path.compact.join(',')
  end

  private
  def domain_can_be_advanced?(dom_str)
    domain_order.domain_can_be_advanced?(dom_str)
  end

  def valid_domain?(dom_str)
    domain_order.valid_domain?(dom_str)
  end

  def finished?(dom_str)
    domain_order.finished?(dom_str)
  end

  def weakest_domain
    student_score.weakest_domain
  end

  def advance_domain!(dom_str)
    student_score.advance_domain!(dom_str)
  end

  def complete_domain!(dom_str)
    student_score.complete_domain!(dom_str)
  end

  def any_domains_incomplete?
    student_score.any_domains_incomplete?
  end
end

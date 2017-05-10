class LearningPathGenerator
  attr_reader :student_score, :domain_order

  UNITS_PER_LEARNING_PATH = 5

  include DomainStringParseable

  def initialize(student_score, domain_order)
    @student_score = student_score
    @domain_order = domain_order
    ensure_min_scores!
    ensure_completed!
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

  def ensure_min_scores!
    student_score.domain_scores.each do |domain, score|
      if below_grade_level?(make_domain_string(domain, score))
        student_score[domain] = lowest_grade_for_domain(domain)
      end
    end
  end

  def ensure_completed!
    student_score.domain_scores.each do |domain, score|
      if above_grade_level?(make_domain_string(domain, score))
        student_score.complete_domain!(make_domain_string(domain, score))
      end
    end
  end

  private
  def domain_can_be_advanced?(dom_str)
    domain_order.domain_can_be_advanced?(dom_str)
  end

  def finished?(dom_str)
    domain_order.finished?(dom_str)
  end

  def lowest_grade_for_domain(domain_name)
    domain_order.lowest_grade_for_domain(domain_name)
  end

  def below_grade_level?(dom_str)
    domain_order.below_grade_level?(dom_str)
  end

  def highet_grade_for_domain(domain_name)
    domain_order.highet_grade_for_domain(domain_name)
  end

  def above_grade_level?(dom_str)
    domain_order.above_grade_level?(dom_str)
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

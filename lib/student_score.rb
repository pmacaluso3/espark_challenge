require 'ostruct'
class StudentScore < OpenStruct
  NON_DOMAIN_HEADERS = [:student_name]
  NON_NUMERIC_SCORES = { 'K' => 0 }

  include KeySanitizable

  def initialize(args = {})
    super(sanitize_args(args))
  end

  def weakest_domain
    domain_scores.each do |k, v|
      return domain_string(k, v) if v == weakest_domain_score
    end
  end

  def domain_scores
    each_pair.reject { |k, v| NON_DOMAIN_HEADERS.include?(k) }.to_h
  end

  private
  def domain_string(domain, grade)
    "#{grade}.#{domain}"
  end

  def sanitize_args(args)
    sanitized_args = {}
    args.each do |k, v|
      sanitized_args[sanitize_key(k)] = convert_non_numeric_score(v)
    end
    sanitized_args
  end

  def convert_non_numeric_score(score)
    if NON_NUMERIC_SCORES[score]
      NON_NUMERIC_SCORES[score]
    else
      score.to_i
    end
  end

  def weakest_domain_score
    domain_scores.values.min
  end
end

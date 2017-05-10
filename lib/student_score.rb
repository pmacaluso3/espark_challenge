require 'ostruct'
require_relative 'key_sanitizable'
require_relative 'domain_string_parseable'

class StudentScore < OpenStruct
  NON_DOMAIN_HEADERS = [:student_name]
  COMPLETION_SCORE = 100

  include KeySanitizable
  include DomainStringParseable

  def initialize(args = {})
    super(sanitize_args(args))
  end

  def advance_domain!(dom_str)
    check_current_domain!(dom_str)
    grade, domain_name = parse_domain_string(dom_str)
    new_grade = self[domain_name] + 1
    send("#{domain_name}=", new_grade)
    make_domain_string(domain_name, grade)
  end

  # the common core info leads me to believe that all domains are contiguous
  # so, if I'm on 2.RF and there's no 3.RF, I can assume I'm done with RF forever
  def complete_domain!(dom_str)
    check_current_domain!(dom_str)
    _grade, domain_name = parse_domain_string(dom_str)
    send("#{domain_name}=", COMPLETION_SCORE)
  end

  def weakest_domain
    domain_scores.each do |k, v|
      return make_domain_string(k, v) if v == weakest_domain_score
    end
  end

  def domain_scores
    each_pair.reject { |k, v| NON_DOMAIN_HEADERS.include?(k) }.to_h
  end

  def any_domains_incomplete?(scores = domain_scores)
    scores.values.any? { |s| s < COMPLETION_SCORE }
  end

  private
  def sanitize_args(args)
    sanitized_args = {}
    args.each do |k, v|
      if NON_DOMAIN_HEADERS.include?(sanitize_key(k))
        sanitized_args[sanitize_key(k)] = v
      else
        sanitized_args[sanitize_key(k)] = convert_non_numeric_score(v)
      end
    end
    sanitized_args
  end

  def weakest_domain_score
    domain_scores.values.min
  end

  class InvalidDomainError < StandardError
  end

  def check_current_domain!(dom_str)
    grade, domain_name = parse_domain_string(dom_str)
    unless self[domain_name] == grade
      raise InvalidDomainError.new "Cannot alter a domain that the student is not currently on."
    end
  end
end

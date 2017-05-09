require_relative 'key_sanitizable'

class DomainOrder
  attr_reader :order

  include KeySanitizable

  def initialize(args = {})
    @order = sanitize_args(args)
  end

  def grades
    order.keys
  end

  def domains_for_grade(grade)
    order[grade]
  end

  def valid_domain?(domain_string)
    grade, domain = domain_string.split('.')
    !!domains_for_grade(grade.to_i).include?(domain.to_sym)
  end

  private
  def sanitize_args(args)
    sanitized_args = {}
    args.each do |grade, domains|
      sanitized_grade = convert_non_numeric_score(grade)
      sanitized_domains = domains.map { |d| sanitize_key(d) }
      sanitized_args[sanitized_grade] = sanitized_domains
    end
    sanitized_args
  end
end

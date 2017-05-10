require_relative 'key_sanitizable'
require_relative 'domain_string_parseable'

class DomainOrder
  attr_reader :order

  include KeySanitizable
  include DomainStringParseable

  def initialize(args = {})
    @order = sanitize_args(args)
  end

  def grades
    order.keys
  end

  def domains_for_grade(grade)
    order[grade]
  end

  def valid_domain?(dom_str)
    grade, domain = parse_domain_string(dom_str)
    !!domains_for_grade(grade.to_i).include?(domain.to_sym)
  end

  def domain_can_be_advanced?(dom_str)
    grade, domain_name = parse_domain_string(dom_str)
    potential_advanced_grade = grade + 1
    potential_new_domain = domain_string(domain_name, potential_advanced_grade)
    valid_domain?(potential_new_domain)
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

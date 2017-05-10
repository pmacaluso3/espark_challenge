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
    return false unless domains_for_grade(grade)
    !!domains_for_grade(grade).include?(domain)
  end

  def finished?(dom_str)
    grade, domain_name = parse_domain_string(dom_str)
    potential_advanced_grade = grade + 1
    potential_new_domain = make_domain_string(domain_name, potential_advanced_grade)
    !valid_domain?(potential_new_domain)
  end

  def lowest_grade_for_domain(domain_name)
    order.each do |grade_level, domains|
      return grade_level if domains.include?(domain_name)
    end
    nil
  end

  def highest_grade_for_domain(domain_name)
    order.reverse_each do |grade_level, domains|
      return grade_level if domains.include?(domain_name)
    end
    nil
  end

  def below_grade_level?(dom_str)
    grade, domain_name = parse_domain_string(dom_str)
    grade < lowest_grade_for_domain(domain_name)
  end

  def above_grade_level?(dom_str)
    grade, domain_name = parse_domain_string(dom_str)
    grade > highest_grade_for_domain(domain_name)
  end

  def expanded_domains
    expansion = []
    order.each do |grade, domains|
      domains.each do |domain|
        expansion << make_domain_string(domain, grade)
      end
    end
    expansion
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

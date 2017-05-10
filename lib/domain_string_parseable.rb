module DomainStringParseable
  NON_NUMERIC_GRADES = { 0 => 'K' }

  def parse_domain_string(dom_str)
    grade = dom_str.split('.').first
    domain = dom_str.split('.').last
    [grade.to_i, domain.to_sym]
  end

  def make_domain_string(domain, grade)
    "#{grade}.#{domain}"
  end

  def print_format(dom_str)
    grade, domain = parse_domain_string(dom_str)
    grade_letter = NON_NUMERIC_GRADES[grade] || grade
    "#{grade_letter}.#{domain.upcase}"
  end
end

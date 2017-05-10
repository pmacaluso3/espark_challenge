module DomainStringParseable
  def parse_domain_string(dom_str)
    grade = dom_str.split('.').first
    domain = dom_str.split('.').last
    [grade.to_i, domain.to_sym]
  end

  def make_domain_string(domain, grade)
    "#{grade}.#{domain}"
  end
end

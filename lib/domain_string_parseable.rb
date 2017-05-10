module DomainStringParseable
  def parse_domain_string(domain_string)
    grade = domain_string.split('.').first
    domain = domain_string.split('.').last
    [grade.to_i, domain.to_sym]
  end
end

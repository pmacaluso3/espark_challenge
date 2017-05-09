require 'csv'

module DomainOrderParser
  DOMAIN_ORDER_FILENAME = File.expand_path('../../data/domain_order.csv', __FILE__)

  def self.read_csv(filename = DOMAIN_ORDER_FILENAME)
    grade_levels = {}
    CSV.foreach(filename) do |row|
      grade = row[0]
      domains = row[1..-1]
      grade_levels[grade] = domains
    end
    grade_levels
  end

  def self.parse(filename = DOMAIN_ORDER_FILENAME)
    csv_data = read_csv
    DomainOrder.new(csv_data)
  end
end

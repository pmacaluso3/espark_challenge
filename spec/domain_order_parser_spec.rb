require_relative 'support/spec_helper'

describe DomainOrderParser do
  let(:test_filename) { app_root + '/spec/data/domain_order.csv' }

  def reset_test_csv
    File.open(test_filename, 'w') do |f|
      f.write("1,RF,RL,RI\n2,RF,RI,RL,L\n")
    end
  end

  before(:each) { reset_test_csv }

  describe '::read_csv' do
    let(:domain_order_data) { DomainOrderParser.read_csv(test_filename) }

    it 'returns a hash' do
      expect(domain_order_data).to be_a Hash
    end

    it 'has one key per row of the csv' do
      expect(domain_order_data.keys.length).to be 2
    end

    it 'has keys equal to the leading values of each row' do
      expect(domain_order_data.keys).to eq(['1', '2'])
    end

    it 'has values equal to the remaining elements of each row' do
      expect(domain_order_data['1']).to eq(['RF', 'RL', 'RI'])
      expect(domain_order_data['2']).to eq(['RF', 'RI', 'RL', 'L'])
    end
  end

  describe '::parse' do
    let(:domain_order) { DomainOrderParser.parse(test_filename) }

    it 'returns a DomainOrder object' do
      expect(domain_order).to be_a(DomainOrder)
    end
  end

end

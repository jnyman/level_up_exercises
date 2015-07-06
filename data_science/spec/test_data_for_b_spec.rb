require 'data_loader'
require 'test_data'

RSpec.describe TestData do
  context 'Test Data Favors B' do
    let(:data_source) { DataLoader.new('data/test_data_favors_b.json') }
    let(:test_data) { TestData.new(data_source.load_data, 'cohort') }

    it 'will determine the sample size' do
      expect(test_data.sample_size).to eq(35)
    end

    it 'will determine the number of trials for group members' do
      expect(test_data.trial_size('B')).to eq(20)
      expect(test_data.trial_size('A')).to eq(15)
    end

    it 'will determine the number of conversions in a group' do
      expect(test_data.conversions_count('B')).to eq(14)
      expect(test_data.conversions_count('A')).to eq(5)
    end

    it 'will determine all group variants' do
      expect(test_data.group_variants).to eq(%w(B A))
    end

    it 'will calculate the conversion percentage of group members' do
      expect(test_data.conversion_percentage('B')).to eq(0.7)
      expect(test_data.conversion_percentage('A')).to eq(0.3333333333333333)
    end

    it 'will calculate the standard error' do
      expect(test_data.standard_error('B')).to eq(0.20084023501280815)
      expect(test_data.standard_error('A')).to eq(0.23856360282447234)
    end

    it 'will calculate the goodness-of-fit' do
      expect(test_data.goodness_of_fit).to eq(0.03116881881121958)
    end

    it 'will determine the variant percentages' do
      expect(test_data.variant_percentages.first).to eq(['B', 0.7])
    end

    it 'will indicate the data favors B' do
      expect(test_data.favored_variant).to eq('The data favored variant B.')
    end
  end
end

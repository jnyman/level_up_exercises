require 'abanalyzer'

class TestData
  attr_reader :data_sample, :group_name

  # The value of 1.96 refers to the 95th percentile of a standard
  # normal distribution. This is multiplied by the standard error.
  CONFIDENCE_INTERVAL = 1.96

  def initialize(data_sample, group_name)
    @data_sample = data_sample
    @group_name = group_name
  end

  def sample_size
    data_sample.length
  end

  def trial_size(variant)
    data_sample.count { |data| data[group_name] == variant }
  end

  def conversions_count(variant, result = 'result')
    data_sample.count do |data|
      data[group_name] == variant && data[result] == 1
    end
  end

  def group_variants
    data_sample.map { |data| data[group_name] }.uniq
  end

  def conversion_percentage(variant)
    conversions_count(variant).to_f / trial_size(variant).to_f
  end

  def standard_error(variant)
    p = conversion_percentage(variant)
    n = trial_size(variant)

    ((Math.sqrt(p * (1 - p) / n)) * CONFIDENCE_INTERVAL)
  end

  # Using the binomial distribution, you can calculate the exact probability
  # of getting a particular set of values over a particular set of trials by
  # defining the number of successes, the number of trials, and the probability
  # of success. If the outcomes are mutually exclusive, then for each possible
  # outcome you can subtract the expected number of that outcome from the
  # observed number of that outcome. Then square the result and divide that
  # squared value by the expected number. Then you sum those values across all
  # possible outcomes and you get the chi-square statistic.
  def goodness_of_fit
    groups = {}

    group_variants.each do |variant|
      groups[variant] = {
        conversions: conversions_count(variant),
        non_conversions: trial_size(variant) - conversions_count(variant) }
    end

    ABAnalyzer::ABTest.new(groups).chisquare_p
  end
end

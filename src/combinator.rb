# builds possible combinations
# according to input data
class Combinator
  def initialize(values, max: 0)
    @values = values
    @max = max
    @combinations = {}
  end

  def call
    with_subsets(values) do |subset|
      duration = sum(subset)
      combinations[duration] = [] unless combinations.key?(duration)
      combinations[duration].push(subset)
    end
    combinations
  end

  private

  attr_reader :values, :max
  attr_accessor :combinations

  # Yield all subsets of the array to the block.
  def with_subsets(array, skip = 0, &block)
    duration = sum(array)
    yield(array) if duration <= max && duration.positive?
    (array.length - 1).downto(skip) do |i|
      with_subsets(array[0...i] + array[i + 1..-1], i, &block)
    end
  end

  # Return the sum of the values.
  def sum(summ_values)
    summ_values.reduce(0) { |memo, hsh| memo + hsh['average_span'] }
  end
end

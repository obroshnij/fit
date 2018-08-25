# calculates consumptions by set of items
class ConsuptionCalculator
  def initialize(data, max: 0)
    @data = data
    @max = max
  end

  def call
    consumptions = []
    valid_combinations.each do |duration, options|
      options.each do |opt|
        consumptions << format_option(duration, opt)
      end
    end
    consumptions
  end

  private

  attr_reader :data, :max

  def valid_combinations
    @valid_combinations = Combinator.new(data, max: max).call
  end

  def format_option(duration, opt)
    {
      duration: duration,
      consumption: opt.reduce(0) { |memo, hsh| memo + hsh['average_calorie_consumption'] },
      items: opt
    }
  end
end

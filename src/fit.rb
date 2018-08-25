class Fit
  attr_accessor :file

  def self.call(options = {})
    instance = new(options)
    instance.perform
  end

  # initialization with default data and attributes
  def initialize(filename: 'sample.json', max: 30)
    @max = max.to_i
    @filename = filename
  end

  # calls method for building available options,
  # selects the most appropriate one
  # and returns result
  def perform
    with_consuptions_calculated do |option_arr|
      @result_item = option_arr.sort_by { |c| c[:consumption] }.last
      write_result
      result
    end
  end

  private

  attr_reader :max, :result_item

  def with_consuptions_calculated
    yield ConsuptionCalculator.new(preprocessed_data, max: max).call
  end

  def preprocessed_data
    data.reject { |row| row['average_span'] > max || row['average_span'].zero? }
  end

  def data
    @data ||= FileHandler.new(File.join(INPUT_FOLDER, @filename)).read
  end

  def result
    return [] unless @result_item

    [
      @result_item[:consumption],
      @result_item[:items]
    ]
  end

  def write_result
    FileHandler.new(File.join(OUTPUT_FOLDER, @filename)).write result
  end
end

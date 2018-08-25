require 'json'

# works with file IO
# has possibility to integrate another interface if necessary
# by introducing another mode
class FileHandler
  def initialize(path)
    @path = path
  end

  def read(mode = :json)
    with_open_file('r') do |file|
      JSON.parse(file.read) if mode == :json
    end
  end

  def write(content, mode = :json)
    with_open_file('w') do |file|
      file.write JSON.pretty_generate(content) if mode == :json
    end
  end

  private

  attr_reader :path

  def with_open_file(mode = 'r')
    yield File.open(path, mode)
  end
end

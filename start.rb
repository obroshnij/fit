Dir.glob('./src/**/*.rb').each { |f| require f }

options = {}
# here we're dealing with command line arguments
options[:max] = ARGV[ARGV.find_index('-max') + 1] if ARGV.include? '-max'
options[:filename] = ARGV[ARGV.find_index('-file') + 1] if ARGV.include? '-file'

Fit.call(options)

require_relative 'lib/csv_parser'
require_relative 'lib/ascii_table_renderer'
require_relative 'lib/formatter'
require_relative 'lib/exceptions'
require_relative 'lib/calculator'

class AsciiTableConverter
  formatter = Formatter.new(parser: CsvParser.new(filepath: ARGV[0]))
  AsciiTableRenderer.new(formatter: formatter).render
end
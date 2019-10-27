class CsvParser
  FILE_DATA_SEPARATOR = ';'.freeze

  attr_reader :filepath

  def initialize(filepath:)
    @filepath = filepath
  end

  def each_row
    validate_document!

    return to_enum(:each_row) { rows_count } unless block_given?

    yield_rows do |row_data|
      record = parsed_headers.zip(row_data).to_h
      yield record
    end
  end

  def validate_document!
    blank_file = rows_count == 0 || parsed_headers.empty?
    raise Exceptions::BlankFile, "Can't parse blank file." if blank_file
  end

  def yield_rows(&block)
    parsed_csv[1..-1].each(&block)
  end

  def parsed_headers
    @parsed_headers ||= parsed_csv[0]
  end

  def parsed_csv
    @parsed_csv ||= File.open(filepath).map do |row|
      row.chomp.split(FILE_DATA_SEPARATOR)
    end
  end

  def rows_count
    @rows_count ||= parsed_csv.length
  end
end
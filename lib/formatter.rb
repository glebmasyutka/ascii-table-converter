class Formatter
  attr_reader :parser

  FORMAT_TYPES = %w(
    int
    string
    money
  )

  def initialize(parser:)
    @parser = parser
  end

  def format
    validate_types

    parser.each_row.to_a.each do |row|
      types.each do |type|
        row[type] = send("format_#{type}_type", row[type])
      end
    end
  end

  def validate_types
    invalid_types = types - FORMAT_TYPES
    return if invalid_types.empty?

    raise Exceptions::InvalidTypes, "#{invalid_types} type(s) is not supported."
  end

  def types
    parser.parsed_headers
  end

  def format_int_type(value)
    [value]
  end

  def format_string_type(value)
    value.split
  end

  def format_money_type(value)
    [value.gsub(/(\d)(?=(\d{3})+(?!\d))/, "\\1\s").sub('.', ',')]
  end
end

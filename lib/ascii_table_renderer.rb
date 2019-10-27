class AsciiTableRenderer
  attr_reader :data, :types, :calculator

  BORDER_PLUS = '+'.freeze
  BORDER_HORIZONTAL_LINE = '-'.freeze
  BORDER_VERTICAL_LINE = '|'.freeze
  ALIGNMENT = ' '.freeze

  def initialize(formatter:)
    @data  = formatter.format
    @types = formatter.types
    @calculator = Calculator.new(data)
  end

  def render
    render_top_border
    data.each { |row| render_row(row) }
  end

  def render_top_border
    border = build_row_border(cell_separator: BORDER_HORIZONTAL_LINE)
    border.gsub!(/.$/, BORDER_PLUS)

    puts border
  end

  def render_row(row)
    amount_subrows = calculator.amount_subrows_for(row)

    amount_subrows.times do |idx|
      subrow = types.each_with_object("#{BORDER_VERTICAL_LINE}") do |type, result|
        result << build_subcell(row[type][idx].to_s, type) + BORDER_VERTICAL_LINE
      end

      puts subrow
    end

    render_row_border
  end

  def render_row_border
    border = build_row_border(cell_separator: BORDER_PLUS)

    puts border
  end

  def build_row_border(cell_separator:)
    types.each_with_object ("#{BORDER_PLUS}") do |type, border|
      border << BORDER_HORIZONTAL_LINE * send("column_width_for_#{type}_type")
      border << cell_separator
    end
  end

  def build_subcell(value, type)
    alignment = ALIGNMENT * (send("column_width_for_#{type}_type") - value.length)
    type == 'string' ? value + alignment : alignment + value
  end

  def column_width_for_int_type
    @column_width_for_int_type ||= calculator.column_width_for_type(type: 'int')
  end

  def column_width_for_string_type
    @column_width_for_string_type ||= calculator.column_width_for_type(type: 'string')
  end

  def column_width_for_money_type
    @column_width_for_money_type ||= calculator.column_width_for_type(type: 'money')
  end
end
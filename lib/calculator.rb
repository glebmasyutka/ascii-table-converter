class Calculator
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def column_width_for_type(type:)
    data.group_by{|h| h[type]}.keys.flatten.max_by(&:length).length
  end

  def amount_subrows_for(row)
    row.values.max_by(&:length).length
  end
end
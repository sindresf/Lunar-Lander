require_relative 'component'

class Solid < Component
  attr_reader :from, :to, :roof
  def initialize(from, to, upper_y)
    @from = from
    @to = to
    @roof = upper_y
  end
end
require_relative 'component'

class Position < Component
  attr_accessor :x, :y
  def initialize(x, y)
    @x = x
    @y = y
  end
end
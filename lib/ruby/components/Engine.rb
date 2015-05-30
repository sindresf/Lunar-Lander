require_relative 'component'

class Engine < Component
  attr_accessor :rel_x, :rel_y, :thrust, :on
  def initialize(thrust, rel_x, rel_y)
    @thrust = thrust
    @rel_x = rel_x
    @rel_y = rel_y
    @on = false
  end
end
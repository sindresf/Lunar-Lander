require_relative 'component'

class SpatialState < Component
  attr_accessor :x, :y, :dx, :dy
  def initialize(x_pos, y_pos, x_vel, y_vel)
    super()
    @x  = x_pos
    @y  = y_pos
    @dx = x_vel
    @dy = y_vel
  end
end
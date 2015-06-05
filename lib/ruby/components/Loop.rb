require_relative 'component'

class Loop < Component
  attr_reader :origin, :loop_y_pos
  def initialize(loop_y_pos, origin_y_pos = 0, tolerance = 0)
    @loop_y_pos = loop_y_pos
    @origin = origin_y_pos
    @tolerance = tolerance
  end

  def looping_time?(current_y_pos)
    return ((current_y_pos <= @loop_y_pos + @tolerance) && (current_y_pos >= @loop_y_pos - @tolerance))
  end
end
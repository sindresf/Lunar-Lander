require_relative 'component'

class Rotation < Component
  attr_accessor :speed, :max
  def initialize(speed, max_rotation = 0)
    @speed = speed
    @max = max_rotation
  end
end
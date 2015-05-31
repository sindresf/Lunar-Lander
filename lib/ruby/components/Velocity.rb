require_relative 'component'

class Velocity < Component
  attr_accessor :horizontal, :vertical
  def initialize(horizontal = 0, vertical = 0)
    @horizontal = horizontal
    @vertical = vertical
  end
end
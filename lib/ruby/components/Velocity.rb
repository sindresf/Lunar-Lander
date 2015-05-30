require_relative 'component'

class Velocity < Component
  attr_accessor :horizontal, :vertical
  def initialize(horizontal, vertical)
    @horizontal = horizontal
    @vertical = vertical
  end
end
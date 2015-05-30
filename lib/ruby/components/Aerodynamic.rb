require_relative 'component'

class Aerodynamics < Component
  attr_accessor :level
  def initialize(level)
    @level = level
  end
end
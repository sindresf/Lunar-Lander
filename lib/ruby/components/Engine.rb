require_relative 'component'

class Engine < Component
  attr_accessor :thrust, :on
  def initialize(thrust)
    @thrust = thrust
    @on = false
  end
end
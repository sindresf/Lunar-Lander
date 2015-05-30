require_relative 'component'

class WindAffected < Component
  attr_accessor :aerodynamics
  def initialize(aerodynamics)
    @aerodynamics = aerodynamics
  end
end
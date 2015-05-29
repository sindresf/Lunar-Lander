require_relative 'component'

class Landable < Component
  attr_accessor :landed
  def initialize
    @landed = false
  end
end
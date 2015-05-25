require_relative 'component'

class UserOption < Component
  attr_accessor :value
  attr_reader :property
  def initialize(property, value = false)
    super()
    @property = property
    @value = value
  end
end
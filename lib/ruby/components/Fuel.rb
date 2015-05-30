require_relative 'component'

class Fuel < Component
  attr_accessor :amount
  def initialize(amount)
    super()
    @amount = amount
  end

  def burn(quantity)
    @amount -= quantity
    @amount = 0 if @amount < 0
  end
end
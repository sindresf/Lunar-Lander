require_relative 'component'

class Life < Component
  attr_accessor :lives
  def initialize(lives)
    @lives = lives
  end
end
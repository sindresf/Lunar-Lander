require_relative 'component'
class Score < Component
  attr_accessor :score
  
  def initialize(score = 0)
    @score = score
  end
end
require_relative 'component'

class Origin < Component
  attr_reader :origin
  def initialize(origin)
    @origin = origin
  end
end
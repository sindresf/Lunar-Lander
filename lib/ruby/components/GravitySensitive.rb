require_relative 'component'

class GravitySensitive < Component
  attr_reader :pull
  def initialize(pull)
    @pull = pull
  end
end
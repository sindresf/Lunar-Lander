require_relative 'component'

class Controls < Component
  attr_reader :responsive_keys
  def initialize(keys)
    super()
    @responsive_keys = keys
  end
end
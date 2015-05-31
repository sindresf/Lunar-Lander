require_relative 'component'

class Collision < Component
  attr_accessor :bounding_polygon
  def marshal_dump
    [@id]
  end

  def marshal_load(array)
    @id = array
  end
end
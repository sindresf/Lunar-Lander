require_relative 'component'
require 'forwardable'

class Renderable < Component
  extend Forwardable
  def_delegators :@image, :width, :height # Its image knows the dimensions.
  attr_accessor :image, :image_path, :scale, :rotation
  def initialize(image_path, scale, rotation)
    super()
    @image_path = image_path
    @image = Texture.new(Gdx.files.internal(image_path))
    @scale = scale
    @rotation = rotation
  end

  def rotate(amount)
    @rotation += amount
  end

  def marshal_dump
    [@id, @image_fn, @scale, @rotation]
  end

  def marshal_load(array)
    @id, @image_fn, @scale, @rotation = array
    @image = Texture.new(Gdx.files.internal(image_fn))
  end
end
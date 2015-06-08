require_relative 'component'
require 'forwardable'

class Renderable < Component
  extend Forwardable
  def_delegators :@image, :width, :height # Its image knows the dimensions.
  attr_accessor :image, :layer, :rotation, :scale, :skin
  def initialize(skin, image_name, scale, rotation, layer = 0)
    super()
    @skin = skin
    @image_name = image_name
    @image_path = "res/images/" + skin + image_name
    @image = Texture.new(Gdx.files.internal(@image_path))
    @scale = scale
    @rotation = rotation
    @layer = layer
  end

  def change_image()
    @image = Texture.new(Gdx.files.internal(@image_path))
  end

  def image_path
    return image_path
  end

  def image_path(skin)
    @image_path = "res/images/" + skin + @image_name
    change_image
  end

  def rotate(amount)
    @rotation += amount
  end

  def marshal_dump
    [@layer, @id, @image_name, @image_path, @scale, @rotation]
  end

  def marshal_load(array)
    @layer, @id, @image_name, @image_path, @scale, @rotation = array
    @image = Texture.new(Gdx.files.internal(image_path))
  end
end
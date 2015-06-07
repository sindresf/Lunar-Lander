class World
  attr_accessor :music, :wind_strength, :gravity_strength, :asteroid_freq, :asteroid_sides, :engine_x, :engine_y #all used In ifs
  attr_reader :name, :skin, :has_wind, :has_gravity # all ifs
  def initialize(name, skin, has_wind, has_gravity) # all ifs
    @skin = skin
    @name = name
    @has_wind = has_wind
    @has_gravity = has_gravity
  end

  def initalize(skin, has_wind, wind_strength, has_gravity, gravity_strength, asteroid_freq)
    @has_wind = has_wind
    @wind_strength = wind_strength
    @has_gravity = has_gravity
    @gravity_strength = gravity_strength
    @asteroid_freq = asteroid_freq
  end

end
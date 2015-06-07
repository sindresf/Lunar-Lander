require 'helper/world'

module WorldMaker
  GRAVITY_STANDARD ||= 0.0045
  ASTEROID_FREQ_STANDARD ||= 80
  ASTEROID_SIDE_STANDARD ||= ['left']

  def WorldMaker.make(world)
    case world
    when 'first'
      return make_first
    when 'neon'
      return make_neon
    when 'solid'
      return make_solid
    when 'whatever'
      return make_whatever
    end
  end

  def self.make_first
    world = World.new('first', "firstskin/", false, true)
    world.engine_x = 0 # TODO don't forget these when animation comes
    world.engine_y = 0
    world.gravity_strength = GRAVITY_STANDARD
    world.asteroid_freq = ASTEROID_FREQ_STANDARD
    world.asteroid_sides = ASTEROID_SIDE_STANDARD
    world.music = Gdx.audio.newMusic Gdx.files.internal("res/music/portivolare.mp3")
    world.music.setVolume 0.25
    return world
  end

  def self.make_neon
    world = World.new('neon', "neonskin/", false, true)
    world.engine_x = 0
    world.engine_y = 0
    world.gravity_strength = GRAVITY_STANDARD
    world.asteroid_freq = ASTEROID_FREQ_STANDARD
    world.asteroid_sides = ['left', 'above']
    world.music = Gdx.audio.newMusic Gdx.files.internal("res/music/flux.mp3")
    world.music.setVolume 0.85
    return world
  end

  def self.make_solid
    world = World.new('solid', "solidskin/", false, true)
    world.engine_x = 0
    world.engine_y = 0
    world.gravity_strength = GRAVITY_STANDARD
    world.asteroid_freq = ASTEROID_FREQ_STANDARD
    world.asteroid_sides = ['left', 'right']
    world.music = Gdx.audio.newMusic Gdx.files.internal("res/music/greenbackboogie.mp3")
    world.music.setVolume 0.65
    return world
  end

  def self.make_whatever
    world = World.new('whatever', "whateverskin/", false, false)
    world.engine_x = 0
    world.engine_y = 0
    return world
  end

end
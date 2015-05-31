module WorldMaker

  GRAVITY_STANDARD = 0.0045
  ASTEROID_FREQ_STANDARD = 40
  ASTEROID_SIDE_STANDARD = 'left'
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

  def make_first
    world = World.new("firstskin/", false, true)
    world.gravity_strength = GRAVITY_STANDARD
    world.asteroid_freq = ASTEROID_FREQ_STANDARD
    world.asteroid_sides = ASTEROID_SIDE_STANDARD
    world.music = Gdx.audio.newMusic Gdx.files.internal("res/music/portivolare.mp3")
    world.music.setVolume 0.25
    return world
  end

  def make_neon
    world = World.new("neonskin/", false, true)
    world.gravity_strength = GRAVITY_STANDARD
    world.asteroid_freq = ASTEROID_FREQ_STANDARD
    world.asteroid_sides = ASTEROID_SIDE_STANDARD
    world.music = Gdx.audio.newMusic Gdx.files.internal("res/music/flux.mp3")
    world.music.setVolume 0.85
    return world
  end

  def make_solid
    world = World.new("solidskin/", false, true)
    world.gravity_strength = GRAVITY_STANDARD
    world.asteroid_freq = ASTEROID_FREQ_STANDARD
    world.asteroid_sides = ASTEROID_SIDE_STANDARD
    world.music = Gdx.audio.newMusic Gdx.files.internal("res/music/greenbackboogie.mp3")
    world.music.setVolume 0.65
    return world
  end

  def make_whatever
    world = World.new("whateverskin/", false, false)
    return world
  end

end
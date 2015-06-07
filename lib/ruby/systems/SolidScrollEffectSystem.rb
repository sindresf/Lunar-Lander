require_relative 'system'

class SolidScrollEffectSystem < System
  AMOUNT = 12
  BACKGROUND_AMOUNT = 25
  INIT_POPULATION = 30
  def initialize(game, world, entity_mgr)
    @game = game
    @world = world
    populate entity_mgr
  end

  def populate(entity_mgr)
    (0..INIT_POPULATION).each do |spawn|
      populate_background_scroll_particle entity_mgr
      populate_background_dot_particle entity_mgr
    end
  end

  def populate_background_scroll_particle(entity_mgr)
    starting_x = rand(896) + 2
    starting_y = rand(550) + 30
    horizontal_vel= rand(2) * 0.01
    if horizontal_vel == 0
      horizontal_vel= -0.03
    end
    vertical_vel = -(0.85 + rand(5) * 0.06)
    spawn_background_particle(starting_x, starting_y, horizontal_vel, vertical_vel, entity_mgr)
  end

  def populate_background_dot_particle(entity_mgr)
    starting_x = rand(896) + 2
    starting_y = rand(550) + 30
    spawn_dot(starting_x, starting_y, -0.4, entity_mgr)
  end

  def spawn_dot(x, y, vertical_vel, entity_mgr)
    asteroid = entity_mgr.create_tagged_entity 'dot'
    entity_mgr.add_component asteroid, Position.new(x, y)
    entity_mgr.add_component asteroid, Velocity.new(0.05, vertical_vel)
    entity_mgr.add_component asteroid, Renderable.new(@world.skin, "scrolleffectpartical.png", 0.1, 0, 1)
    entity_mgr.add_component asteroid, Motion.new
  end

  def process_one_game_tick(delta, entity_mgr)
    spawn_background_scroll_particle entity_mgr
    spawn_scroll_particle entity_mgr
    cleanup_particles entity_mgr
  end

  def spawn_background_scroll_particle(entity_mgr)
    spawn = rand BACKGROUND_AMOUNT
    if spawn == 0
      starting_x = rand(896) + 2
      starting_y = 610
      horizontal_vel= rand(2) * 0.01
      if horizontal_vel == 0
        horizontal_vel= -0.03
      end
      vertical_vel = -(0.85 + rand(5) * 0.06)
      spawn_background_particle(starting_x, starting_y, horizontal_vel, vertical_vel, entity_mgr)
    end
  end

  def spawn_scroll_particle(entity_mgr)
    spawn = rand AMOUNT
    if spawn == 0
      starting_x = rand(896) + 2
      starting_y = 650
      horizontal_vel= -0.4 + rand(4) * 0.25
      vertical_vel = rand(2) - 21
      spawn_particle(starting_x, starting_y, horizontal_vel, vertical_vel, entity_mgr)
    end
  end

  def spawn_particle(x, y, horizontal_vel, vertical_vel, entity_mgr)
    asteroid = entity_mgr.create_tagged_entity 'particle'
    entity_mgr.add_component asteroid, Position.new(x, y)
    entity_mgr.add_component asteroid, Velocity.new(horizontal_vel, vertical_vel)
    entity_mgr.add_component asteroid, Renderable.new(@world.skin, "scrolleffectpartical.png", 1, 0, 10)
    entity_mgr.add_component asteroid, Motion.new
  end

  def spawn_background_particle(x, y, horizontal_vel, vertical_vel, entity_mgr)
    asteroid = entity_mgr.create_tagged_entity 'back_particle'
    entity_mgr.add_component asteroid, Position.new(x, y)
    entity_mgr.add_component asteroid, Velocity.new(horizontal_vel, vertical_vel)
    scale = 0.25 + rand(12) * 0.0125
    entity_mgr.add_component asteroid, Renderable.new(@world.skin, "scrolleffectpartical.png", scale, 0, 1)
    entity_mgr.add_component asteroid, Motion.new
  end

  def cleanup_particles entity_mgr
    cleanup_scroll_particles entity_mgr
    cleanup_background_scroll_particles entity_mgr
    cleanup_dots entity_mgr
  end

  def cleanup_scroll_particles entity_mgr
    particles = entity_mgr.get_all_entities_tagged_with('particle') || []
    particles.each do |particle|
      position = entity_mgr.get_component_of_type particle, Position
      if position.y < -20
        entity_mgr.kill_entity(particle)
      end
    end
  end

  def cleanup_background_scroll_particles entity_mgr
    particles = entity_mgr.get_all_entities_tagged_with('back_particle') || []
    particles.each do |particle|
      position = entity_mgr.get_component_of_type particle, Position
      if position.y < -20
        entity_mgr.kill_entity(particle)
      end
    end
  end

  def cleanup_dots entity_mgr
    particles = entity_mgr.get_all_entities_tagged_with('dot') || []
    particles.each do |dot|
      position = entity_mgr.get_component_of_type dot, Position
      if position.y < -20
        entity_mgr.kill_entity(dot)
      end
    end
  end
end
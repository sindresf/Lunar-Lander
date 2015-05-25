require_relative 'system'

class AsteroidSystem < System
  HOW_OFTEN = 40 # framerate = 60 -> statistically an asteroid a sec
  def generate_new_asteroids(delta, entity_mgr)
    if rand(HOW_OFTEN) == 0
      starting_x = -100
      starting_y = rand(950) - 150
      starting_dx = rand(15) + 2
      starting_dy = rand(20) - 10
      asteroid_scale = (0.5 * (2.5 / (starting_dx * 0.2))) + (rand() * 0.9)
      asteroid_rotation = 8.0 + rand(48)
      asteroid = entity_mgr.create_tagged_entity 'asteroid'
      entity_mgr.add_component asteroid, SpatialState.new(starting_x, starting_y, starting_dx, starting_dy)
      entity_mgr.add_component asteroid, Renderable.new(RELATIVE_ROOT + "res/images/asteroid.png", asteroid_scale, asteroid_rotation)
      entity_mgr.add_component asteroid, PolygonCollidable.new
      entity_mgr.add_component asteroid, Motion.new
    end
  end

  def cleanup_asteroids(delta, entity_mgr)
    asteroid_entities = entity_mgr.get_all_entities_tagged_with('asteroid') || []

    asteroid_entities.each do |a|
      spatial_component = entity_mgr.get_component_of_type(a, SpatialState)
      if spatial_component.x > 900
        entity_mgr.kill_entity(a)
      end
    end
  end

  def process_one_game_tick(delta, entity_mgr)
    generate_new_asteroids(delta, entity_mgr)
    cleanup_asteroids(delta, entity_mgr)
  end
end
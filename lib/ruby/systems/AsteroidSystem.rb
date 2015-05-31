require_relative 'system'

class AsteroidSystem < System
  HOW_OFTEN = 80 # framerate = 60 -> statistically an asteroid a sec
  def initialize(game, world)
    @game = game
    @world = world
  end

  def generate_new_asteroids(delta, entity_mgr)
    make = rand(HOW_OFTEN)
    #TODO make dependent on world asteroid origins
    if make == 0 # make beyond the left side asteroid
      starting_x = -100
      starting_y = rand(950) - 150
      starting_dx = rand(15) + 2
      if starting_y > 160
        starting_dy = rand(20) - 10
      else
        starting_dy = rand(20) + 1
      end
      make_asteroid(starting_dx, starting_dy, entity_mgr, starting_x, starting_y)
    elsif make == 5 # make from above asteroid
      starting_x = rand(500)
      starting_y = 1000
      starting_dx = rand(7) + 2
      starting_dy = rand(8) - 10
      make_asteroid(starting_dx, starting_dy, entity_mgr, starting_x, starting_y)
    end
  end

  def make_asteroid(starting_dx, starting_dy, entity_mgr, starting_x, starting_y)
    asteroid_scale = (0.5 * (2.5 / (starting_dx * 0.2))) + (rand() * 0.9) # scales size on speed
    asteroid_rotation = 8.0 + rand(48)
    asteroid = entity_mgr.create_tagged_entity 'asteroid'
    entity_mgr.add_component asteroid, Position.new(starting_x, starting_y)
    entity_mgr.add_component asteroid, Velocity.new(starting_dx, starting_dy)
    # TODO incorporate this renderable levels thingsy
    entity_mgr.add_component asteroid, Renderable.new(@world.skin, "asteroid.png", asteroid_scale, asteroid_rotation, 10)
    entity_mgr.add_component asteroid, Collision.new
    entity_mgr.add_component asteroid, Motion.new
  end

  def cleanup_asteroids(delta, entity_mgr)
    asteroid_entities = entity_mgr.get_all_entities_tagged_with('asteroid') || []

    asteroid_entities.each do |a|
      position_component = entity_mgr.get_component_of_type(a, Position)
      if position_component.x > 900
        entity_mgr.kill_entity(a)
      elsif position_component.y < 125 && position_component.y > 0
        entity_mgr.kill_entity(a)
      end
    end
  end

  def process_one_game_tick(delta, entity_mgr)
    # TODO generate_new_background_asteroid(delta, entity_mgr)
    generate_new_asteroids(delta, entity_mgr)
    cleanup_asteroids(delta, entity_mgr)
  end
end
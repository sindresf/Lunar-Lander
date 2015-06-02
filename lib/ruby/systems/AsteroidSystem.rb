require_relative 'system'

class AsteroidSystem < System
  SIDE_NR = [0,1,2,3]

  def initialize(game, world)
    @game = game
    @world = world
    @make_freq = @world.asteroid_freq * @world.asteroid_sides.length
  end

  def generate_new_asteroids(delta, entity_mgr) # TODO make this ALSO make background, or seperate thing?
    make = rand(@make_freq)
    #TODO make dependent on world asteroid origins

    @world.asteroid_sides.each do |side|
      if is_making_left_asteroid_time?(side, make)
        make_left_asteroid entity_mgr

      elsif is_making_above_asteroid_time?(side, make)
        make_above_asteroid entity_mgr

      elsif is_making_right_asteroid_time?(side, make)
        make_right_asteroid entity_mgr

      elsif is_making_below_asteroid_time?(side, make)
        make_below_asteroid entity_mgr
      end
    end
  end

  def is_making_left_asteroid_time?(side, make)
    return side == 'left' && make == SIDE_NR[0]
  end

  def make_left_asteroid(entity_mgr)
    starting_x = -100
    starting_y = rand(500) + 170
    horizontal_vel= rand(12) + 3
    if starting_y < 240
      vertical_vel = rand(4) + 0.2
    else
      vertical_vel = rand(12) - 10
    end
    make_asteroid(starting_x, starting_y, horizontal_vel, vertical_vel, 'left', entity_mgr)
  end

  def is_making_above_asteroid_time?(side, make)
    return side == 'above' && make == SIDE_NR[1]
  end

  def make_above_asteroid(entity_mgr)
    starting_x = rand(500) + 200
    starting_y = 700
    horizontal_vel= rand(10) - 5
    if horizontal_vel== 0
      horizontal_vel= 1
    end
    vertical_vel = rand(7) - 10
    make_asteroid(starting_x, starting_y, horizontal_vel, vertical_vel, 'above', entity_mgr)
  end

  def is_making_right_asteroid_time?(side, make)
    return side == 'right' && make == SIDE_NR[2]
  end

  def make_right_asteroid(entity_mgr)
    starting_x = 1000
    starting_y = rand(500) + 170
    horizontal_vel= rand(12) - 15
    if starting_y < 240
      vertical_vel = rand(4) + 0.2
    else
      vertical_vel = rand(12) - 10
    end
    make_asteroid(starting_x, starting_y, horizontal_vel, vertical_vel, 'right', entity_mgr)
  end

  def is_making_below_asteroid_time?(side, make)
    return side == 'below' && make == SIDE_NR[3]
  end

  def make_below_asteroid(entity_mgr)
    make_asteroid(starting_x, starting_y, horizontal_vel, vertical_vel, 'below', entity_mgr)
  end

  def make_asteroid(x, y, horizontal_vel, vertical_vel, origin, entity_mgr)
    asteroid_scale = (0.5 * (2.5 / (horizontal_vel* 0.2))) + (rand() * 0.9) # scales size on speed
    asteroid_rotation = 8.0 + rand(48)
    asteroid = entity_mgr.create_tagged_entity 'asteroid'
    entity_mgr.add_component asteroid, Position.new(x, y)
    entity_mgr.add_component asteroid, Velocity.new(horizontal_vel, vertical_vel)
    # TODO incorporate this renderable levels thingsy
    entity_mgr.add_component asteroid, Renderable.new(@world.skin, "asteroid.png", asteroid_scale, asteroid_rotation, 10)
    entity_mgr.add_component asteroid, Collision.new
    entity_mgr.add_component asteroid, Motion.new
    entity_mgr.add_component asteroid, Origin.new(origin)
  end

  def cleanup_asteroids(delta, entity_mgr)
    asteroid_entities = entity_mgr.get_all_entities_tagged_with('asteroid') || []

    asteroid_entities.each do |a|
      killed = false
      origin = entity_mgr.get_component_of_type(a, Origin)
      case origin.origin
      when 'left'
        if kill_when_above a, entity_mgr
        elsif kill_beyond_right a, entity_mgr
        elsif kill_on_ground_hit a, entity_mgr
        end
      when 'above'
        if kill_beyond_left a, entity_mgr
        elsif kill_beyond_right a, entity_mgr
        elsif  kill_on_ground_hit a, entity_mgr
        end
      when 'right'
        if  kill_when_above a, entity_mgr
        elsif kill_beyond_left a, entity_mgr
        elsif kill_on_ground_hit a, entity_mgr
        end
      when 'below'
        if kill_beyond_left a, entity_mgr
        elsif kill_beyond_right a, entity_mgr
        elsif kill_when_above a, entity_mgr
        end
      end
    end
  end

  def kill_on_ground_hit(asteroid, entity_mgr)
    ground_hit = 110 + (rand(40) - 20)
    position = entity_mgr.get_component_of_type(asteroid, Position)
    if position.y < ground_hit && position.y > 0
      entity_mgr.kill_entity(asteroid)
      return true
    end
    return false
  end

  def kill_beyond_left(asteroid, entity_mgr)
    image = entity_mgr.get_component_of_type(asteroid, Renderable)
    position = entity_mgr.get_component_of_type(asteroid, Position)
    asteroid_right = position.x + image.width
    if asteroid_right < 0
      entity_mgr.kill_entity(asteroid)
      return true
    end
    return false
  end

  def kill_when_above(asteroid,entity_mgr)
    position = entity_mgr.get_component_of_type(asteroid, Position)
    if position.y > 600
      entity_mgr.kill_entity(asteroid)
      return true
    end
    return false
  end

  def kill_beyond_right(asteroid, entity_mgr)
    position = entity_mgr.get_component_of_type(asteroid, Position)
    if position.x > 900
      entity_mgr.kill_entity(asteroid)
      return true
    end
    return false
  end

  def process_one_game_tick(delta, entity_mgr)
    # TODO generate_new_background_asteroid(delta, entity_mgr)
    generate_new_asteroids(delta, entity_mgr)
    cleanup_asteroids(delta, entity_mgr)
  end
end
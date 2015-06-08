require_relative 'system'
require 'helper/renderinglevels'
require 'helper/transitionlevels'

class MakeAsteroidSystem < System
  include RenderingLevels
  include TransitionLevels
  SIDE_NR = [0,1,2,3]

  def initialize(game, world, transitioning)
    @game = game
    @world = world
    @make_freq = @world.asteroid_freq * @world.asteroid_sides.length
    @transitioning = transitioning
  end

  def generate_new_asteroids(delta, entity_mgr) # TODO make this ALSO make background, or seperate thing?
    make = rand(@make_freq)

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
    starting_y = rand(501) + 170
    horizontal_vel= rand(13) + 3
    if starting_y < 240
      vertical_vel = rand(5) + 0.2
    else
      vertical_vel = rand(13) - 10
    end
    asteroid_scale = (0.5 * (2.5 / (horizontal_vel* 0.2))) + (rand() * 0.9) # scales size on speed
    make_asteroid(starting_x, starting_y, horizontal_vel, vertical_vel, 'left', asteroid_scale, entity_mgr)
  end

  def is_making_above_asteroid_time?(side, make)
    return side == 'above' && make == SIDE_NR[1]
  end

  def make_above_asteroid(entity_mgr)
    starting_x = rand(501) + 200
    starting_y = 700
    horizontal_vel= rand(11) - 5
    if horizontal_vel== 0
      horizontal_vel= 1
    end
    vertical_vel = rand(8) - 10
    asteroid_scale = (0.5 * (2.5 / (-vertical_vel* 0.2))) + (rand() * 0.9) # scales size on speed
    make_asteroid(starting_x, starting_y, horizontal_vel, vertical_vel, 'above', asteroid_scale, entity_mgr)
  end

  def is_making_right_asteroid_time?(side, make)
    return side == 'right' && make == SIDE_NR[2]
  end

  def make_right_asteroid(entity_mgr)
    starting_x = 1000
    starting_y = rand(501) + 170
    horizontal_vel= rand(13) - 15
    if starting_y < 240
      vertical_vel = rand(5) + 0.2
    else
      vertical_vel = rand(13) - 10
    end
    asteroid_scale = (0.5 * (2.5 / (-horizontal_vel* 0.2))) + (rand() * 0.9) # scales size on speed
    make_asteroid(starting_x, starting_y, horizontal_vel, vertical_vel, 'right', asteroid_scale, entity_mgr)
  end

  def is_making_below_asteroid_time?(side, make)
    return side == 'below' && make == SIDE_NR[3]
  end

  def make_below_asteroid(entity_mgr)
    starting_x = rand(501) + 200
    starting_y = -100
    horizontal_vel= rand(10) - 5
    if horizontal_vel== 0
      horizontal_vel= 1
    end
    vertical_vel = rand(8) + 3
    asteroid_scale = (0.5 * (2.5 / (vertical_vel* 0.2))) + (rand() * 0.9) # scales size on speed
    make_asteroid(starting_x, starting_y, horizontal_vel, vertical_vel, 'below', asteroid_scale, entity_mgr)
  end

  def make_asteroid(x, y, horizontal_vel, vertical_vel, origin, scale, entity_mgr)
    asteroid_rotation = 8.0 + rand(49)
    asteroid = entity_mgr.create_tagged_entity 'asteroid'
    entity_mgr.add_component asteroid, Position.new(x, y)
    entity_mgr.add_component asteroid, Velocity.new(horizontal_vel, vertical_vel)
    rotation_coeff = horizontal_vel * 0.1
    if vertical_vel <= 0
      entity_mgr.add_component asteroid, Rotation.new(-0.09 * rotation_coeff)
    else
      entity_mgr.add_component asteroid, Rotation.new(0.09 * rotation_coeff)
    end

    if @transitioning
      level = (rand(2) + 1) * 2
      entity_mgr.add_component asteroid, Renderable.new(@world.skin, "asteroid.png", scale, asteroid_rotation, level)
    else
      index = rand(4)
      level = ASTEROID_INTERACTIVE[index]
      entity_mgr.add_component asteroid, Renderable.new(@world.skin, "asteroid.png", scale, asteroid_rotation, level)
    end
    entity_mgr.add_component asteroid, Collision.new
    entity_mgr.add_component asteroid, Motion.new
    entity_mgr.add_component asteroid, Origin.new(origin)
  end

  def process_one_game_tick(delta, entity_mgr)
    # TODO generate_new_background_asteroid(delta, entity_mgr)
    generate_new_asteroids(delta, entity_mgr)

  end
end
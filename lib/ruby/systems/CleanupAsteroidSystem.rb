require_relative 'system'

class CleanupAsteroidSystem < System
  def initialize(game)
    @game = game
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
    cleanup_asteroids(delta, entity_mgr)
  end

end
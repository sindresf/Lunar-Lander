require_relative 'system'

class AsteroidRotationSystem < System
  ROTATE_TIMER = 0.05
  def initialize(game)
    @game = game
    @time = Time.now
  end

  def process_one_game_tick(delta, entity_mgr)
    asteroids = entity_mgr.get_all_entities_with_components_of_type([Rotation, Origin])
    check_time
    if @should_rotate_asteroids
      asteroids.each do |asteroid|
        renderable_component = entity_mgr.get_component_of_type(asteroid, Renderable)
        rotation = entity_mgr.get_component_of_type(asteroid, Rotation)
        renderable_component.rotate(delta * rotation.speed)
      end
    end
  end

  def check_time
    @should_rotate_asteroids = false
    if Time.now - @time >= ROTATE_TIMER
      @should_rotate_asteroids = true
      @time = Time.now
    end
  end

end
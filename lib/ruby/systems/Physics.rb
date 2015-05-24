require_relative 'system'

class Physics < System
  # This constant could conceivably live in the gravity component...
  ACCELERATION = 0.005 # m/s^2
  DOWN = Math.cos(Math::PI)
  MOVE_SCALER = 0.01
  def process_one_game_tick(delta, entity_mgr)
    gravity_entities = entity_mgr.get_all_entities_with_component_of_type(GravitySensitive)
    gravity_entities.each do |e|
      spatial_component = entity_mgr.get_component_of_type(e, SpatialState)

      # vertical speed will feel gravity's effect
      spatial_component.dy += ACCELERATION * delta
    end

    moving_entities = entity_mgr.get_all_entities_with_component_of_type(Motion)
    moving_entities.each do |e|
      spatial_component = entity_mgr.get_component_of_type(e, SpatialState)

      # move horizontally according to dx
      amount = MOVE_SCALER * delta * spatial_component.dx
      spatial_component.x += (amount)

      # now fall according to dy
      amount = MOVE_SCALER * delta * spatial_component.dy
      spatial_component.y += (amount * DOWN)
    end
  end
end
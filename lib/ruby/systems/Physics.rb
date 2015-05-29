require_relative 'system'

class Physics < System
  # This constant could conceivably live in the gravity component...
  ACCELERATION = 0.0045 # m/s^2
  DOWN = Math.cos(Math::PI)
  MOVE_SCALER = 0.013
  STOP_ACCEPT = 30
  def process_one_game_tick(delta, entity_mgr)
    stop_movement = false
    gravity_entities = entity_mgr.get_all_entities_with_component_of_type GravitySensitive
    solid_entities = entity_mgr.get_all_entities_with_component_of_type Solid
    solid_surfaces = []
    solid_entities.each do |solid|
      solid_component = entity_mgr.get_component_of_type(solid, Solid)
      surface = [solid_component.from, solid_component.to, solid_component.roof]
      solid_surfaces.push surface
    end
    gravity_entities.each do |e|
      spatial_component = entity_mgr.get_component_of_type(e, SpatialState)
      landable_component = entity_mgr.get_component_of_type(e,Landable)

      #test for landing on solid "surfaces"
      if !landable_component.nil?
        solid_surfaces.each do |surface|
          if (spatial_component.x >= surface[0] - STOP_ACCEPT && spatial_component.x <= surface[1] + STOP_ACCEPT) &&
          (spatial_component.y >= surface[2] - 1 && spatial_component.y <= surface[2] + 1)
            stop_movement = true
          else
            stop_movement = false
          end
        end
        if !stop_movement
          spatial_component.dy += ACCELERATION * delta
        else
          entity_mgr.remove_component e, GravitySensitive
          entity_mgr.remove_component e, PlayerInput
          spatial_component.dy = 0
          spatial_component.dx = 0
        end
      else
        spatial_component.dy += ACCELERATION * delta
      end
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
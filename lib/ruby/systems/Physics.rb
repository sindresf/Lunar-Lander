require_relative 'system'

class Physics < System
  # This constant could conceivably live in the gravity component...
  MOVE_SCALER = 0.013
  STOP_ACCEPT = 15 # TODO this needs to be SO much better
  def initialize(game, gravity_ACCELERATION = 0)
    @game = game
    @ACCELERATION = -gravity_ACCELERATION
  end

  def process_one_game_tick(delta, entity_mgr, movement_system)
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
      position_component = entity_mgr.get_component_of_type(e, Position)
      velocity_component = entity_mgr.get_component_of_type(e, Velocity)
      landable_component = entity_mgr.get_component_of_type(e,Landable)

      #test for landing on solid "surfaces"
      if !landable_component.nil?
        solid_surfaces.each do |surface|
          # TODO make a check for Around Surface center, is now around surface left edge
          if (position_component.x >= (surface[0] - STOP_ACCEPT) && position_component.x <= surface[1] + STOP_ACCEPT) &&
          (position_component.y >= surface[2] - 1 && position_component.y <= surface[2])
            stop_movement = true
          else
            stop_movement = false
          end
        end
        if !stop_movement
          velocity_component.vertical += @ACCELERATION * delta
        else
          entity_mgr.remove_component e, GravitySensitive
          entity_mgr.remove_component e, Controls
          velocity_component.vertical = 0
          velocity_component.horizontal = 0
        end
      else
        velocity_component.vertical += @ACCELERATION * delta
      end
    end
    movement_system.process_one_game_tick(delta,entity_mgr)
  end
end
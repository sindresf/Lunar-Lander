require_relative 'system'

class MovementSystem < System
  MOVE_SCALER = 0.013
  def process_one_game_tick(delta, entity_mgr)

    moving_entities = entity_mgr.get_all_entities_with_component_of_type(Motion)
    moving_entities.each do |e|
      position_component = entity_mgr.get_component_of_type(e, Position)
      velocity_component = entity_mgr.get_component_of_type(e, Velocity)

      amount = MOVE_SCALER * delta * velocity_component.horizontal
      position_component.x += (amount)

      amount = MOVE_SCALER * delta * velocity_component.vertical
      position_component.y += amount
    end
  end
end
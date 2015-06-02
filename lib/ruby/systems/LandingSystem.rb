require_relative 'system'

class LandingSystem < System
  PIXEL_FUDGE = 2
  MAX_SPEED = -5
  MAX_ROTATION = 10 # TODO or something proper
  def process_one_game_tick(delta, entity_mgr)
    landable_entities = entity_mgr.get_all_entities_with_component_of_type Landable
    pad_entities = entity_mgr.get_all_entities_with_component_of_type Pad
    landable_entities.each do |entity|
      position_component = entity_mgr.get_component_of_type(entity, Position)
      landing_velocity = entity_mgr.get_component_of_type(entity, Velocity)
      renderable_component = entity_mgr.get_component_of_type(entity, Renderable)
      landing_x_pos = position_component.x
      landing_y_pos = position_component.y
      landing_center_x = landing_x_pos + (renderable_component.width / 2)

      pad_entities.each do |pad|
        pad_location_component = entity_mgr.get_component_of_type(pad, Position)
        pad_rend_component = entity_mgr.get_component_of_type(pad, Renderable)
        pad_y_pos = pad_location_component.y + pad_rend_component.height
        if landing_on_pad_height?(landing_y_pos, pad_y_pos)
          pad_x_left = pad_location_component.x
          pad_x_right = pad_x_left + pad_rend_component.width
          ur_y = pad_y_pos
          if is_on_pad_area?(landing_center_x, pad_x_left, pad_x_right) && is_slow_enough?(landing_velocity.vertical)
            landable_component = entity_mgr.get_component_of_type(entity, Landable)
            landable_component.landed = true
            return true
          end
        end
      end
    end
    return false
  end

  def landing_on_pad_height?(land_y, pad_y)
    return (land_y >= pad_y - PIXEL_FUDGE && land_y <= pad_y + PIXEL_FUDGE)
  end

  def is_on_pad_area?(landing_center_x, pad_x_left, pad_x_right)
    return (landing_center_x >= pad_x_left + 5 && landing_center_x <= pad_x_right - 5) # 5 is for 'center of gravity' balancing
  end

  def is_slow_enough?(velocity)
    return (velocity  <= MAX_SPEED)
  end
end
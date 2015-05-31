require_relative 'system'

class LandingSystem < System
  PIXEL_FUDGE = 2
  MAX_SPEED = 5
  def process_one_game_tick(delta, entity_mgr)
    landable_entities = entity_mgr.get_all_entities_with_component_of_type Landable
    pad_entities = entity_mgr.get_all_entities_with_component_of_type Pad
    landable_entities.each do |entity|
      position_component = entity_mgr.get_component_of_type(entity, Position)
      velocity_component = entity_mgr.get_component_of_type(entity, Velocity)
      renderable_component = entity_mgr.get_component_of_type(entity, Renderable)
      bl_x = position_component.x
      bl_y = position_component.y
      bc_x = bl_x + (renderable_component.width / 2)
      br_x = bl_x + renderable_component.width
      br_y = bl_y
      pad_entities.each do |pad|
        pad_loc_component = entity_mgr.get_component_of_type(pad, Position)
        pad_rend_component = entity_mgr.get_component_of_type(pad, Renderable)
        ul_x = pad_loc_component.x
        ul_y = pad_loc_component.y + pad_rend_component.height
        ur_x = ul_x + pad_rend_component.width
        ur_y = ul_y
        if (bl_y>=ul_y - PIXEL_FUDGE && bl_y <= ul_y + PIXEL_FUDGE) &&
        (bc_x>=ul_x && bc_x <= ur_x) &&
        (velocity_component.vertical <= MAX_SPEED)
          landable_component = entity_mgr.get_component_of_type(entity, Landable)
          landable_component.landed = true
          return true
        end
      end
    end
    return false
  end
end
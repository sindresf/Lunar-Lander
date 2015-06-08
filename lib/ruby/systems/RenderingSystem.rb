require_relative 'system'
require 'helper/renderinglevels'
require 'helper/transitionlevels'

class RenderingSystem < System
  include RenderingLevels
  include TransitionLevels
  def process_one_game_tick(levels, entity_mgr, batch, font)
    @levels = levels
    (0...levels).each do |level|
      draw_level(level, entity_mgr, batch)
    end
    draw_fuel_info entity_mgr, batch, font
  end

  def draw_level(level, entity_mgr, batch)
    is_plural_level = is_plural_drawables_level(level)
    drawables = entity_mgr.get_all_entities_with_components_of_type([Renderable, Position])
    drawables.each do |drawable|
      renderable_component = entity_mgr.get_component_of_type(drawable, Renderable)
      if renderable_component.layer == level
        draw_entity(drawable, entity_mgr, batch)
        if !is_plural_level
          return
        end
      end
    end
  end

  def is_plural_drawables_level(level)
    if level == 0
      return false
    end
    if @levels == LEVELS
      if level == ASTEROID_BACKGROUND
        return true
      elsif ASTEROID_INTERACTIVE.include?(level)
        return true
      else
        return false
      end
    elsif @levels == LEVEL_COUNT
      if level == BG_SCROLL
        return true
      elsif level == BG_OBJECTS
        return true
      elsif level == FRONT_OBJECTS
        return true
      elsif level == FRONT_SCROLL
        return true
      else
        return false
      end
    end
  end

  def draw_entity(entity, entity_mgr, batch)
    position_component = entity_mgr.get_component_of_type(entity, Position)
    velocity_component = entity_mgr.get_component_of_type(entity, Velocity)
    render_comp = entity_mgr.get_component_of_type(entity, Renderable)

    batch.draw(render_comp.image, position_component.x, position_component.y,
    render_comp.width/2, render_comp.height/2,
    render_comp.width, render_comp.height,
    render_comp.scale,  render_comp.scale,
    render_comp.rotation,
    0, 0,
    render_comp.width, render_comp.height,
    false, false
    )
  end

  def draw_fuel_info(entity_mgr, batch, font)
    fuel_x = 75
    entities = entity_mgr.get_all_entities_with_component_of_type Fuel
    entities.each_with_index do |e, index|
      fuel_component   = entity_mgr.get_component_of_type(e, Fuel)
      font.draw(batch, "Player #{index + 1} Fuel remaining #{sprintf "%.1f" % fuel_component.amount}", 8, fuel_x);
      fuel_x += 15
    end
  end

  def process_one_game_tick2(delta, entity_mgr, camera, batch, font)
    entities = entity_mgr.get_all_entities_with_components_of_type([Renderable, Position])
    entities.each do |e|
      position_component = entity_mgr.get_component_of_type(e, Position)
      velocity_component = entity_mgr.get_component_of_type(e, Velocity)
      render_comp = entity_mgr.get_component_of_type(e, Renderable)

      batch.draw(render_comp.image, position_component.x, position_component.y,
      render_comp.width/2, render_comp.height/2,
      render_comp.width, render_comp.height,
      render_comp.scale,  render_comp.scale,
      render_comp.rotation,
      0, 0,
      render_comp.width, render_comp.height,
      false, false
      )
    end
    fuel_x = 75
    entities = entity_mgr.get_all_entities_with_component_of_type Fuel
    entities.each_with_index do |e, index|
      fuel_component   = entity_mgr.get_component_of_type(e, Fuel)
      font.draw(batch, "Player #{index + 1} Fuel remaining #{sprintf "%.1f" % fuel_component.amount}", 8, fuel_x);
      fuel_x += 15
    end
  end
end
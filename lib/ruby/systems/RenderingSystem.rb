require_relative 'system'

class RenderingSystem < System
  def initialize(game, levels)
    @game = game
    @levels = levels
  end

  def process_one_game_tick2(delta, entity_mgr, camera, batch, font)

  end

  def process_one_game_tick(delta, entity_mgr, camera, batch, font)
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
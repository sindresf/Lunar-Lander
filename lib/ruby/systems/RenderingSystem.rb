require_relative 'system'

class RenderingSystem < System
  def process_one_game_tick(entity_mgr, camera, batch, font)
    entities = entity_mgr.get_all_entities_with_components_of_type([Renderable, SpatialState])
    entities.each do |e|
      loc_comp    = entity_mgr.get_component_of_type(e, SpatialState)
      render_comp = entity_mgr.get_component_of_type(e, Renderable)

      batch.draw(render_comp.image, loc_comp.x, loc_comp.y,
      render_comp.width/2, render_comp.height/2,
      render_comp.width, render_comp.height,
      render_comp.scale,  render_comp.scale,
      render_comp.rotation,
      0, 0,
      render_comp.width, render_comp.height,
      false, false
      )
    end

    entities = entity_mgr.get_all_entities_with_component_of_type(Fuel)
    entities.each_with_index do |e, index|
      fuel_component   = entity_mgr.get_component_of_type(e, Fuel)
      font.draw(batch, "Fuel remaining #{sprintf "%.1f" % fuel_component.remaining}", 8, 90);
    end
  end
end
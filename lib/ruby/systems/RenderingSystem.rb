require_relative 'system'

class RenderingSystem < System
  def initialize(game)
    @game = game
    @time = Time.now
  end

  def process_one_game_tick(delta, entity_mgr, camera, batch, font)
    rot_ast = false
    if Time.now - @time >= 0.05
      rot_ast = true
      @time = Time.now
    end
    entities = entity_mgr.get_all_entities_with_components_of_type([Renderable, SpatialState])
    entities.each do |e|
      loc_comp    = entity_mgr.get_component_of_type(e, SpatialState)
      render_comp = entity_mgr.get_component_of_type(e, Renderable)

      if entity_mgr.get_tag(e) == 'asteroid' && rot_ast
        clock_dir = 1 # wise
        if loc_comp.dy >= 0
          clock_dir = -1 # anti -wise
        end
        render_comp.rotate(delta * (clock_dir * (0.04 + (0.01 * loc_comp.dx))))
      end

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
    fuel_x = 75
    entities = entity_mgr.get_all_entities_with_component_of_type(Fuel)
    entities.each_with_index do |e, index|
      fuel_component   = entity_mgr.get_component_of_type(e, Fuel)
      font.draw(batch, "Player #{index + 1} Fuel remaining #{sprintf "%.1f" % fuel_component.remaining}", 8, fuel_x);
      fuel_x += 15
    end
  end
end
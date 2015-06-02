require_relative 'system'

class RenderingSystem < System
  def initialize(game)
    @game = game
    @time = Time.now
  end

  def process_one_game_tick(delta, entity_mgr, camera, batch, font)
    should_rotate_asteroid = false
    if Time.now - @time >= 0.05
      should_rotate_asteroid = true
      @time = Time.now
    end
    entities = entity_mgr.get_all_entities_with_components_of_type([Renderable, Position])
    entities.each do |e|
      position_component = entity_mgr.get_component_of_type(e, Position)
      velocity_component = entity_mgr.get_component_of_type(e, Velocity)
      render_comp = entity_mgr.get_component_of_type(e, Renderable)

      if entity_mgr.get_tag(e) == 'asteroid' && should_rotate_asteroid
        clock_dir = -1 # anti - wise
        if velocity_component.vertical >= 0
          clock_dir = 1 # wise
        end
        render_comp.rotate(delta * (clock_dir * (0.04 + (0.01 * velocity_component.horizontal))))
      end

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
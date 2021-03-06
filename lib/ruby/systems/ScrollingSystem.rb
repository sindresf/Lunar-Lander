require_relative 'system'

class ScrollingSystem < System
  def process_one_game_tick(delta, entity_mgr)
    scroll_entities = entity_mgr.get_all_entities_with_component_of_type Loop
    scroll_entities.each do |entity|
      loop = entity_mgr.get_component_of_type(entity, Loop)
      position = entity_mgr.get_component_of_type(entity, Position)

      if loop.looping_time?(position.y.round(1))
        # offset = loop.loop_y_pos - (loop.loop_y_pos + position.y) # TODO actual think about this
        position.y = loop.origin # + offset# TODO needs to consider the amount of, to not jerk
      end
    end
  end
end
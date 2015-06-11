require_relative 'system'

java_import com.badlogic.gdx.math.Polygon
java_import com.badlogic.gdx.math.Intersector

class CollisionSystem < System
  def make_polygon(position_x, width, position_y, height, rotation, scale)
    polygon = Polygon.new(
    [0, 0,
      width, 0,
      width, height,
      0, height])

    polygon.setPosition(position_x, position_y)
    polygon.setRotation(rotation)

    return polygon
  end

  def update_bounding_polygons(entity_mgr, entities)
    entities.each do |e|
      position_component    = entity_mgr.get_component_of_type(e, Position)
      renderable_component = entity_mgr.get_component_of_type(e, Renderable)
      collidable_component = entity_mgr.get_component_of_type(e, Collision)

      collidable_component.bounding_polygon = make_polygon(position_component.x,
      renderable_component.width,
      position_component.y,
      renderable_component.height,
      renderable_component.rotation,
      renderable_component.scale)
    end
  end

  def process_one_game_tick(delta, entity_mgr)
    collidable_entities = []

    polygon_entities = entity_mgr.get_all_entities_with_component_of_type Collision
    update_bounding_polygons(entity_mgr, polygon_entities)
    collidable_entities += polygon_entities

    bounding_areas={}
    collidable_entities.each do |e|
      bounding_areas[e] = entity_mgr.get_component_of_type(e, Collision).bounding_polygon
    end

    player_entities = []

    polygon_entities = entity_mgr.get_all_entities_with_component_of_type Controls
    update_bounding_polygons(entity_mgr, polygon_entities)
    player_entities += polygon_entities

    player_bounding_areas={}
    player_entities.each do |e|
      player_bounding_areas[e] = entity_mgr.get_component_of_type(e, Collision).bounding_polygon
    end

    bounding_areas.each_key do |entity|
      player_bounding_areas.each_key do |player|
        next if is_same_polygon?(entity, player)
        next if is_player_clash?(entity_mgr, entity, player)

        #OK, so we care, check it out
        if is_crash?(bounding_areas, entity, player)

          if is_player1_crash?(entity_mgr, player)
            if with_asteroid?(entity_mgr, entity)
              register_player_hit(player, entity_mgr)
            elsif with_ground?(entity_mgr, entity)
              life_component = entity_mgr.get_component_of_type(player, Life)
              life_component.lives = 0
            end

          elsif is_player2_crash?(entity_mgr, player)
            if with_asteroid?(entity_mgr, entity)
              register_player_hit(player, entity_mgr)
            elsif with_ground?(entity_mgr, entity)
              life_component = entity_mgr.get_component_of_type(player, Life)
              life_component.lives = 0
            end
          end
        end
      end
    end
  end

  # Helper ifs for readability
  def is_same_polygon?(entity, player)
    return entity == player
  end

  def is_player_clash?(entity_mgr, entity, other)
    return ((entity_mgr.get_tag(entity) == 'p1_lander') && (entity_mgr.get_tag(other) == 'p2_lander')) || ((entity_mgr.get_tag(entity) == 'p2_lander') && (entity_mgr.get_tag(other) == 'p1_lander'))
  end

  def is_crash?(bounding_areas, entity, player)
    return Intersector.overlapConvexPolygons(bounding_areas[entity], bounding_areas[player])
  end

  def is_player1_crash?(entity_mgr, player)
    return entity_mgr.get_tag(player) == 'p1_lander'
  end

  def is_player2_crash?(entity_mgr, player)
    return (entity_mgr.get_tag(player) == 'p2_lander')
  end

  def with_asteroid?(entity_mgr, entity)
    return (entity_mgr.get_tag(entity) == 'asteroid')
  end

  def with_ground?(entity_mgr, entity)
    return (entity_mgr.get_tag(entity) == 'ground')
  end

  def register_player_hit(player, entity_mgr)
    life_component = entity_mgr.get_component_of_type(player, Life)
    score_component = entity_mgr.get_component_of_type(player, Score)
    life_component.lives -= 1
    score_component.score -= 200
  end
end
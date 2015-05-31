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
      bounding_areas[e]=entity_mgr.get_component_of_type(e, Collision).bounding_polygon
    end

    # Naive O(n^2) (kinda)
    bounding_areas.each_key do |entity|
      bounding_areas.each_key do |other|
        #All the don't care situations
        # list in occurrence order for max efficiency
        next if is_asteroid_clash?(entity_mgr, entity, other)
        next if is_just_asteroid_hitting_ground?(entity_mgr, entity, other)
        next if is_just_asteroid_hitting_platform?(entity_mgr, entity, other)
        next if is_same_polygon?(entity, other)
        next if is_just_platform_on_ground?(entity_mgr, entity, other)
        next if is_player_clash?(entity_mgr, entity, other)

        #OK, so we care, check it out
        if is_crash?(bounding_areas, entity, other)
          if is_player1_crash?(entity_mgr, entity, other)
            return true
          elsif is_player2_crash?(entity_mgr, entity, other)
            return true
          else
            return false
          end
        end
      end
    end
    return false
  end

  # Helper ifs for readability
  def is_same_polygon?(entity, other)
    return entity == other
  end

  def is_asteroid_clash?(entity_mgr, entity, other)
    return (entity_mgr.get_tag(entity) == 'asteroid') && (entity_mgr.get_tag(other) == 'asteroid')
  end

  def is_just_platform_on_ground?(entity_mgr, entity, other)
    return ((entity_mgr.get_tag(entity) == 'platform') && (entity_mgr.get_tag(other) == 'ground')) || ((entity_mgr.get_tag(entity) == 'ground') && (entity_mgr.get_tag(other) == 'platform'))
  end

  def is_just_asteroid_hitting_ground?(entity_mgr, entity, other)
    return ((entity_mgr.get_tag(entity) == 'ground') && (entity_mgr.get_tag(other) == 'asteroid')) || ((entity_mgr.get_tag(entity) == 'asteroid') && (entity_mgr.get_tag(other) == 'ground'))
  end

  def is_just_asteroid_hitting_platform?(entity_mgr, entity, other)
    return ((entity_mgr.get_tag(entity) == 'platform') && (entity_mgr.get_tag(other) == 'asteroid')) || ((entity_mgr.get_tag(entity) == 'asteroid') && (entity_mgr.get_tag(other) == 'platform'))
  end

  def is_player_clash?(entity_mgr, entity, other)
    return ((entity_mgr.get_tag(entity) == 'p1_lander') && (entity_mgr.get_tag(other) == 'p2_lander')) || ((entity_mgr.get_tag(entity) == 'p2_lander') && (entity_mgr.get_tag(other) == 'p1_lander'))
  end

  def is_crash?(bounding_areas, entity, other)
    return Intersector.overlapConvexPolygons(bounding_areas[entity], bounding_areas[other])
  end

  def is_player1_crash?(entity_mgr, entity, other)
    return (entity_mgr.get_tag(entity) == 'p1_lander') || (entity_mgr.get_tag(other) == 'p1_lander')
  end

  def is_player2_crash?(entity_mgr, entity, other)
    return (entity_mgr.get_tag(entity) == 'p2_lander') || (entity_mgr.get_tag(other) == 'p2_lander')
  end

end
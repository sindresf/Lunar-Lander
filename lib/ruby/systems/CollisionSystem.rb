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
      spatial_component    = entity_mgr.get_component_of_type(e, SpatialState)
      renderable_component = entity_mgr.get_component_of_type(e, Renderable)
      collidable_component = entity_mgr.get_component_of_type(e, PolygonCollidable)

      collidable_component.bounding_polygon = make_polygon(spatial_component.x,
      renderable_component.width,
      spatial_component.y,
      renderable_component.height,
      renderable_component.rotation,
      renderable_component.scale)
    end
  end

  def process_one_game_tick(delta, entity_mgr)
    collidable_entities = []

    polygon_entities = entity_mgr.get_all_entities_with_component_of_type PolygonCollidable
    update_bounding_polygons(entity_mgr,polygon_entities)
    collidable_entities += polygon_entities

    bounding_areas={}
    collidable_entities.each do |e|
      bounding_areas[e]=entity_mgr.get_component_of_type(e, PolygonCollidable).bounding_polygon
    end

    # Naive O(n^2)
    bounding_areas.each_key do |entity|
      bounding_areas.each_key do |other|
        next if entity == other

        # TODO FIX THIS LIKE A MOFO!
        if Intersector.overlapConvexPolygons(bounding_areas[entity], bounding_areas[other])
          if is_player1?(entity_mgr, entity, other)
            if is_player2?(entity_mgr, entity, other)
              # puts "playa playa"
            else
              # puts "Intersection 1!"
              return true
            end
          end
          if is_player2?(entity_mgr, entity, other)
            if is_player1?(entity_mgr, entity, other)
              # puts "playa playa"
            else
              # puts "Intersection 2!"
              return true
            end
          end
        end
      end
    end
  end

  private

  def is_player1?(entity_mgr, entity, other)
    return entity_mgr.get_tag(entity) == 'p1_lander' || entity_mgr.get_tag(other) =='p1_lander'
  end

  def is_player2?(entity_mgr, entity, other)
    return entity_mgr.get_tag(entity) == 'p2_lander' || entity_mgr.get_tag(other) =='p2_lander'
  end

end
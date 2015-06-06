require_relative 'system'

class StraighteningSystem < System
  P1_KEY_LEFT   = Input::Keys::A
  P1_KEY_RIGHT  = Input::Keys::D
  P2_KEY_LEFT   = Input::Keys::J
  P2_KEY_RIGHT  = Input::Keys::L
  STRAIGHT_TILT = 0
  STRAIGHTEN_TILT_STEP = 0.04
  MOVE_DECELERATION = 0.01
  STOP = 0
  LEFT = -1
  RIGHT = 1
  def initialize(game, multiplayer)
    @game = game
    @multiplayer = multiplayer
  end

  def process_one_game_tick(delta, entity_mgr)
    player_entities = entity_mgr.get_all_entities_with_components_of_type [Renderable, Controls]

    player_entities.each do |entity|
      player = entity_mgr.get_tag entity
      if player == 'p1_lander' && !player1_control_pressed?
        straighten(delta,entity,entity_mgr)
        stop(delta, entity, entity_mgr)
      end
      if @multiplayer
        if player == 'p2_lander' && !player2_control_pressed?
          straighten(delta,entity,entity_mgr)
          stop(delta, entity, entity_mgr)
        end
      end
    end
  end

  def player1_control_pressed?
    return Gdx.input.isKeyPressed(P1_KEY_LEFT) ||
    Gdx.input.isKeyPressed(P1_KEY_RIGHT)
  end

  def straighten(delta, entity, entity_mgr)
    renderable_component = entity_mgr.get_component_of_type entity, Renderable
    if renderable_component.rotation.abs < 0.05
      renderable_component.rotation = 0
    else
      if renderable_component.rotation <= -0.05
        renderable_component.rotation += STRAIGHTEN_TILT_STEP * delta
      elsif renderable_component.rotation >= 0.05
        renderable_component.rotation -= STRAIGHTEN_TILT_STEP * delta
      end
    end
  end

  def stop(delta, entity, entity_mgr)
    velocity = entity_mgr.get_component_of_type entity, Velocity
    if velocity.horizontal.abs < 0.02
      velocity.horizontal = 0
    else
      if velocity.horizontal <= -0.02
        velocity.horizontal += MOVE_DECELERATION * delta
      elsif velocity.horizontal >= 0.02
        velocity.horizontal -= MOVE_DECELERATION * delta
      end
    end
  end

  def player2_control_pressed?
    return Gdx.input.isKeyPressed(P2_KEY_LEFT) ||
    Gdx.input.isKeyPressed(P2_KEY_RIGHT)
  end
end
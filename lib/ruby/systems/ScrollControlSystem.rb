require_relative 'system'

class ScrollControlSystem < System
  P1_KEY_LEFT   = Input::Keys::A
  P1_KEY_RIGHT  = Input::Keys::D
  P2_KEY_LEFT   = Input::Keys::J
  P2_KEY_RIGHt  = Input::Keys::L
  MOVE_TILT = 12 # degrees of rotation while moving horizontally
  TILT_STEP = 0.04 # "tilt acceleration"
  MOVE_ACCELERATION = 0.09
  MAX_SPEED = 4
  LEFT = -1
  RIGHT = 1
  def initialize(game, multiplayer)
    @game = game
    @multiplayer = multiplayer
  end

  def process_one_game_tick(delta, entity_mgr)
    controllable_entities = entity_mgr.get_all_entities_with_component_of_type Controls
    controllable_entities.each do |entity|
      control_component = entity_mgr.get_component_of_type(entity, Controls)
      handle_player1_controls(control_component, entity_mgr, entity, delta)
      if @multiplayer
        handle_player2_controls(control_component, entity_mgr, entity, delta)
      end
    end
  end

  def handle_player1_controls(control_component, entity_mgr, entity, delta)
    if move_left_input?(control_component, entity_mgr, 1)
      renderable_component = entity_mgr.get_component_of_type(entity, Renderable)
      if renderable_component.rotation < MOVE_TILT
        renderable_component.rotate(delta * TILT_STEP)
      end
      move_in_dir(delta, LEFT, entity, entity_mgr)
    elsif move_right_input?(control_component, entity_mgr, 1)
      renderable_component = entity_mgr.get_component_of_type(entity, Renderable)
      if renderable_component.rotation > -MOVE_TILT
        renderable_component.rotate(delta * -TILT_STEP)
      end
      move_in_dir(delta, RIGHT, entity, entity_mgr)
    end
  end

  def handle_player2_controls(control_component, entity_mgr, entity, delta)
    if move_left_input?(control_component, entity_mgr, 2)
      renderable_component=entity_mgr.get_component_of_type(entity, Renderable)
      if renderable_component.rotation < MOVE_TILT
        renderable_component.rotate(delta * TILT_STEP)
      end
      move_in_dir(delta, LEFT, entity, entity_mgr)
    elsif move_right_input?(control_component, entity_mgr, 2)
      renderable_component=entity_mgr.get_component_of_type(entity, Renderable)
      if renderable_component.rotation > -MOVE_TILT
        renderable_component.rotate(delta * -TILT_STEP)
      end
      move_in_dir(delta, RIGHT, entity, entity_mgr)
    end
  end

  def move_left_input?(control_component, entity_mgr, player)
    if player == 1
      return Gdx.input.isKeyPressed(P1_KEY_LEFT) &&
      control_component.responsive_keys.include?(P1_KEY_LEFT)
    elsif player == 2
      return Gdx.input.isKeyPressed(P2_KEY_LEFT) &&
      control_component.responsive_keys.include?(P2_KEY_LEFT)
    end
  end

  def move_right_input?(control_component, entity_mgr, player)
    if player == 1
      return Gdx.input.isKeyPressed(P1_KEY_RIGHT) &&
      control_component.responsive_keys.include?(P1_KEY_RIGHT)
    elsif player == 2
      return Gdx.input.isKeyPressed(P2_KEY_RIGHt) &&
      control_component.responsive_keys.include?(P2_KEY_RIGHt)
    end
  end

  def move_in_dir(delta, dir, entity, entity_mgr)
    velocity = entity_mgr.get_component_of_type(entity, Velocity)
    position = entity_mgr.get_component_of_type(entity, Position)
    if dir == -1
      if position.x >= 1
        if velocity.horizontal >= -MAX_SPEED
          velocity.horizontal += MOVE_ACCELERATION * dir * delta
        end
      else
        velocity.horizontal = 0
      end
    elsif dir == 1
      renderable_component = entity_mgr.get_component_of_type(entity, Renderable)
      if position.x + renderable_component.width <= 899
        if velocity.horizontal <= MAX_SPEED
          velocity.horizontal += MOVE_ACCELERATION * dir * delta
        end
      else
        velocity.horizontal = 0
      end
    end

  end
end
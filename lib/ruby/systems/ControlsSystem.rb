require_relative 'system'

class ControlsSystem < System
  # Presumably these would be DRYed into a config file... the fuck?
  # TODO look into this config file thing
  P1_KEY_ROTL   = Input::Keys::A
  P1_KEY_THRUST = Input::Keys::S
  P1_KEY_ROTR   = Input::Keys::D
  P2_KEY_ROTL   = Input::Keys::J
  P2_KEY_THRUST = Input::Keys::K
  P2_KEY_ROTR   = Input::Keys::L
  def process_one_game_tick(delta, entity_mgr)
    controllable_entities = entity_mgr.get_all_entities_with_component_of_type Controls
    controllable_entities.each do |entity|
      control_component = entity_mgr.get_component_of_type(entity, Controls)
      handle_player1(control_component, entity_mgr, entity, delta)
      handle_player2(control_component, entity_mgr, entity, delta)
    end
  end

  private

  def handle_player1(control_component, entity_mgr, entity, delta)
    if Gdx.input.isKeyPressed(P1_KEY_THRUST) &&
    control_component.responsive_keys.include?(P1_KEY_THRUST) &&
    entity_mgr.has_component_of_type?(entity, Engine)
      engine_component = entity_mgr.get_component_of_type(entity, Engine)
      engine_component.on = true
    end
    if Gdx.input.isKeyPressed(P1_KEY_ROTL) &&
    control_component.responsive_keys.include?(P1_KEY_ROTL)

      renderable_component = entity_mgr.get_component_of_type(entity, Renderable)
      rotation = entity_mgr.get_component_of_type(entity, Rotation)
      renderable_component.rotate(delta * rotation.speed)
    end

    if Gdx.input.isKeyPressed(P1_KEY_ROTR) &&
    control_component.responsive_keys.include?(P1_KEY_ROTR)

      renderable_component = entity_mgr.get_component_of_type(entity, Renderable)
      rotation = entity_mgr.get_component_of_type(entity, Rotation)
      renderable_component.rotate(delta * - rotation.speed)
    end
  end

  private

  def handle_player2(control_component, entity_mgr, entity, delta)
    if Gdx.input.isKeyPressed(P2_KEY_THRUST) &&
    control_component.responsive_keys.include?(P2_KEY_THRUST) &&
    entity_mgr.has_component_of_type?(entity, Engine)
      engine_component = entity_mgr.get_component_of_type(entity, Engine)
      engine_component.on = true
    end
    if Gdx.input.isKeyPressed(P2_KEY_ROTL) &&
    control_component.responsive_keys.include?(P2_KEY_ROTL)

      renderable_component=entity_mgr.get_component_of_type(entity, Renderable)
      renderable_component.rotate(delta * 0.1)
    end

    if Gdx.input.isKeyPressed(P2_KEY_ROTR) &&
    control_component.responsive_keys.include?(P2_KEY_ROTR)

      renderable_component=entity_mgr.get_component_of_type(entity, Renderable)
      renderable_component.rotate(delta * -0.1)
    end
  end
end
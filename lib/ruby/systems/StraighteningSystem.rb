require_relative 'system'

class StraighteningSystem < System
  def initialize(game, multiplayer)
    @game = game
    @multiplayer = multiplayer
  end

  def process_one_game_tick(delta, entity_mgr)
    if !any_control_pressed?
      # TODO straighten
    end
  end

  # TODO make this check pr. player (and work ofc)
  def any_control_pressed?
    return true
    if @multiplayer
      return Gdx.input.isKeyPressed(P1_KEY_LEFT) ||
      Gdx.input.isKeyPressed(P1_KEY_RIGHT) ||
      Gdx.input.isKeyPressed(P2_KEY_LEFT) ||
      Gdx.input.isKeyPressed(P2_KEY_RIGHt)
    else
      return Gdx.input.isKeyPressed(P1_KEY_LEFT) ||
      Gdx.input.isKeyPressed(P1_KEY_RIGHT)
    end
  end
end
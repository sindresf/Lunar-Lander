require_relative 'system'

class NeonScrollLinesSystem < System
  AMOUNT = 30
  BACKGROUND_AMOUNT = 15
  # TODO Make a list of neon colour defenitions
  def process_one_game_tick(delta, enity_mgr)
    spawn_background_scroll_line
    spawn_scroll_line
  end

  def spawn_background_scroll_line
    spawn = rand BACKGROUND_AMOUNT
    if spawn == 0
      # TODO make a line with a neon colour
    end
  end

  def spawn_scroll_line
    spawn = rand AMOUNT
    if spawn == 0
      # TODO make a line with a neon colour
    end
  end
end
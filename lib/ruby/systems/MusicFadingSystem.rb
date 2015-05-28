require_relative 'system'

class MusicFadingSystem < System
  def initialize(game, music)
    @game = game
    @music = music
  end

  def process_one_game_tick(not_run)
  end

  def fade_out(time)
    steps = 15.0
    decrease = 1 / steps
    step = 1
    volume = 1
    new_volume = volume - decrease
    while true
      if new_volume <= 0
        @music.pause
        break
      end
      @music.setVolume(new_volume)
      sleep time / steps
      new_volume = new_volume - decrease
    end
  end

  def fade_in(time)

  end
end
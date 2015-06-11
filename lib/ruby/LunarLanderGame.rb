java_import com.badlogic.gdx.Game
require_relative 'startup_screen'

class LunarLanderGame < Game
  include ApplicationListener
  attr_reader :game_clock, :is_running
  attr_accessor :score
  GAME_CLOCK_MULTIPLIER=1
  def initialize
    @is_running = true
    @score = 0
  end

  def create
    @game_clock = Time.utc(2015,"may",1,20,15,1)
    setScreen(StartupScreen.new(self))
  end

  def increment_game_clock(seconds)
    @game_clock += seconds
  end

  def dispose
    @is_running = false
  end
end
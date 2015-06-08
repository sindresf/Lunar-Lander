java_import com.badlogic.gdx.Screen
java_import com.badlogic.gdx.Audio
java_import com.badlogic.gdx.audio.Music

require 'lunar_lander_em'
require 'systems/useroptionsystem'
require 'systems/renderingsystem'
require 'components/useroption'
require 'components/renderable'
require 'components/position'
require 'helper/WorldMaker'

class ResultScreen
  include Screen
  def initialize(game, menu_screen, world, multiplayer, muted)
    @game = game
    @menu_screen = menu_screen
    @world = world
    @multiplayer = multiplayer
    @muted = muted
    @bg_song = Gdx.audio.newMusic(Gdx.files.internal("res/music/wearethechampions.mp3"))
    @bg_song.setVolume 0.8
  end

  def show
    @result_entity_manager = Lunar_lander_em.new @game

    bg_image = @result_entity_manager.create_tagged_entity 'background'
    @result_entity_manager.add_component bg_image, Renderable.new(@world.skin, 'result.png', 1.0, 0)
    @result_entity_manager.add_component bg_image, Position.new(0 ,0)

    # TODO make if statements for "who won" / "win/loss"
    lunar_lander = @result_entity_manager.create_tagged_entity 'lunar_lander'
    @result_entity_manager.add_component lunar_lander, Renderable.new(@world.skin, 'lunarlander.png', 1.0, 0, 1)
    @result_entity_manager.add_component lunar_lander, Position.new(150, 90)

    # TODO get Who won
    lander = @result_entity_manager.create_tagged_entity 'lander'
    @result_entity_manager.add_component lander, Position.new(420,150)
    @result_entity_manager.add_component lander, Renderable.new(@world.skin, "crashlander1.png", 1.2, 0, 2)

    @rendering_system = RenderingSystem.new @game
    @user_option_system = UserOptionSystem.new @game, self, @world, @bg_song

    @camera = OrthographicCamera.new
    @camera.setToOrtho(false, 900, 600);
    @batch = SpriteBatch.new
    @font = BitmapFont.new
    @bg_song.play
  end

  def hide
  end

  def render(gdx_delta)
    delta = gdx_delta * 1000

    @camera.update
    @batch.setProjectionMatrix(@camera.combined)

    @batch.begin

    @user_option_system.process_one_game_tick @result_entity_manager
    @rendering_system.process_one_game_tick(3, @result_entity_manager, @batch, @font)
    @batch.end

    if Gdx.input.isKeyPressed(Input::Keys::ENTER)
      @bg_song.stop
      @bg_song.dispose
      @game.setScreen @menu_screen
    end

  end

  def resize width, height
  end

  # On Android this method is called when the Home button is pressed or an
  # incoming call is received. On desktop this is called just before dispose()
  # when exiting the application.
  # A good place to save the game state.
  def pause
  end

  # This method is only called on Android, when the application resumes from a
  # paused state.
  def resume
  end

  # Called when the application is destroyed. It is preceded by a call to pause().
  def dispose
    @bg_song.stop
    @bg_song.dispose
  end
end
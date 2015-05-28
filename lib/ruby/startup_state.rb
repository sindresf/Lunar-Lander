java_import com.badlogic.gdx.Screen
java_import com.badlogic.gdx.Audio

require 'playing_state'
require 'lunar_lander_em'
require 'systems/useroptionsystem'
require 'systems/renderingsystem'
require 'components/useroption'
require 'components/renderable'
require 'components/spatialstate'

class StartupState
  include Screen
  def initialize(game)
    @game = game
    @skin = "firstskin/"
    @bg_song = Gdx.audio.newMusic(Gdx.files.internal("res/music/ghostwriter.mp3"))
    @bg_song.setVolume 0.25
  end

  def show
    @option_entity_manager = Lunar_lander_em.new @game

    bg_image = @option_entity_manager.create_tagged_entity 'background'
    @option_entity_manager.add_component bg_image, Renderable.new(@skin, 'startup.png', 1.0, 0)
    @option_entity_manager.add_component bg_image, SpatialState.new(0 ,0, 0, 0)

    lunar_lander = @option_entity_manager.create_tagged_entity 'lunar_lander'
    @option_entity_manager.add_component lunar_lander, Renderable.new(@skin, 'lunarlander.png', 1.0, 0)
    x_center = 900 / 2
    y_center = 135
    x =  x_center - (@option_entity_manager.get_component_of_type(lunar_lander, Renderable).width / 2)
    y = y_center - (@option_entity_manager.get_component_of_type(lunar_lander, Renderable).height / 2)
    @option_entity_manager.add_component lunar_lander, SpatialState.new(x, y, 0, 0)

    skin_option = @option_entity_manager.create_tagged_entity 'option'
    @option_entity_manager.add_component skin_option, UserOption.new('skin', 'firstskin/')

    start_option = @option_entity_manager.create_tagged_entity 'start'
    @option_entity_manager.add_component start_option, UserOption.new('start')

    @rendering_system = RenderingSystem.new @game
    @user_option_system = UserOptionSystem.new @game, self, @skin, @bg_song

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
    # Make sure you "layer" things in here from bottom to top...
    @camera.update
    @batch.setProjectionMatrix(@camera.combined)

    @batch.begin

    @user_option_system.process_one_game_tick(@option_entity_manager)

    @rendering_system.process_one_game_tick(delta, @option_entity_manager,@camera,@batch,@font)
    # @batch.draw(@bg_image, 0, 0)
    #  @batch.draw(@lunar_lander, 150, 250)

    @font.draw(@batch, "P to play!", 8, 100);
    @font.draw(@batch, "S to skin!", 8, 80);
    @font.draw(@batch, "1/2 to choose players!", 8, 60);
    if @user_option_system.multiplayer
      @font.draw(@batch,  "multiplayer", 36, 46);
    else
      @font.draw(@batch,  "singleplayer", 29, 46);
    end
    @font.draw(@batch, "Lunar Lander (Q to exit)", 8, 20);
    @font.draw(@batch, "M to mute!", 820, 20);

    @batch.end

    if Gdx.input.isKeyPressed(Input::Keys::Q)
      @bg_song.stop
      @bg_song.dispose
      Gdx.app.exit
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


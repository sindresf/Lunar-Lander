java_import com.badlogic.gdx.Screen

require 'playing_state'

class StartupState
  include Screen
  def initialize(game)
    @game = game
  end

  def show
    @bg_image = Texture.new(Gdx.files.internal(RELATIVE_ROOT + 'res/images/background.png'))
    @camera = OrthographicCamera.new
    @camera.setToOrtho(false, 900, 600);
    @batch = SpriteBatch.new
    @font = BitmapFont.new
  end

  def hide
  end

  def render(gdx_delta)
    # Make sure you "layer" things in here from bottom to top...
    @camera.update
    @batch.setProjectionMatrix(@camera.combined)

    @batch.begin

    @batch.draw(@bg_image, 0, 0)

    @font.draw(@batch, "P to play!", 8, 250);
    @font.draw(@batch, "Lunar Lander (Q to exit)", 8, 20);

    @batch.end

    if Gdx.input.isKeyPressed(Input::Keys::Q)
      Gdx.app.exit
    elsif Gdx.input.isKeyPressed(Input::Keys::P)
      @game.setScreen PlayingState.new(@game)
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
  end
end


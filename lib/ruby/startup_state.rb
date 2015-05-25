java_import com.badlogic.gdx.Screen

require 'playing_state'
require 'lunar_lander_em'
require 'systems/useroptionsystem'
require 'systems/renderingsystem'
require 'components/useroption'
require 'components/renderable'

class StartupState
  include Screen
  def initialize(game)
    @game = game
    @skin = "res/images/firstskin/"
  end

  def show
    @option_entity_manager = Lunar_lander_em.new @game

    bg_image = @option_entity_manager.create_tagged_entity 'background'
    @option_entity_manager.add_component bg_image, Renderable.new(RELATIVE_ROOT + @skin + 'startup.png', 1.0, 0)

    lunar_lander = @option_entity_manager.create_tagged_entity 'lunar_lander'
    @option_entity_manager.add_component lunar_lander, Renderable.new(RELATIVE_ROOT + @skin + 'lunarlander.png', 1.0, 0)

    skin_option = @option_entity_manager.create_tagged_entity 'option'
    @option_entity_manager.add_component skin_option, UserOption.new('skin', 'res/images/firstskin/')

    start_option = @option_entity_manager.create_tagged_entity 'start'
    @option_entity_manager.add_component start_option, UserOption.new('start')

    @bg_image = Texture.new(Gdx.files.internal(RELATIVE_ROOT + @skin + 'startup.png'))
    @lunar_lander = Texture.new(Gdx.files.internal(RELATIVE_ROOT + @skin + 'lunarlander.png'))

    @rendering_system = RenderingSystem.new @game
    @user_option_system = UserOptionSystem.new @game

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

    @user_option_system.process_one_game_tick(@option_entity_manager)

    @batch.draw(@bg_image, 0, 0)
    @batch.draw(@lunar_lander, 150, 250)

    @font.draw(@batch, "P to play!", 15, 250);
    @font.draw(@batch, "S to skin!", 15, 180);
    @font.draw(@batch, "Lunar Lander (Q to exit)", 8, 20);

    @batch.end

    if Gdx.input.isKeyPressed(Input::Keys::Q)
      Gdx.app.exit
    elsif Gdx.input.isKeyPressed(Input::Keys::S)
      @skin = "res/images/solidskin/"
      @bg_image = Texture.new(Gdx.files.internal(RELATIVE_ROOT + @skin + 'startup.png'))
      @lunar_lander =  Texture.new(Gdx.files.internal(RELATIVE_ROOT + @skin + 'lunarlander.png'))
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


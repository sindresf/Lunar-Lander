java_import com.badlogic.gdx.Screen
java_import com.badlogic.gdx.Audio
java_import com.badlogic.gdx.audio.Music

require 'playing_screen'
require 'lunar_lander_em'
require 'systems/useroptionsystem'
require 'systems/renderingsystem'
require 'components/useroption'
require 'components/renderable'
require 'components/position'
require 'helper/WorldMaker'

class StartupScreen
  include Screen
  def initialize(game)
    @game = game
    @world = WorldMaker.make 'first'
    @bg_song = Gdx.audio.newMusic(Gdx.files.internal("res/music/ghostwriter.mp3"))
    @bg_song.setVolume 0.25
    @bg_song.setLooping true # TODO FIGURE OUT THIS BULLSHIT! !! ! ! ! !
    loop = @bg_song.isLooping
    if !loop
      Gdx.audio.music.setPan(-0.8, 0.80)
      @bg_song.setPosition(20) # seconds
    else
      puts "god hates me"
    end
  end

  def show
    @option_entity_manager = Lunar_lander_em.new @game

    bg_image = @option_entity_manager.create_tagged_entity 'background'
    @option_entity_manager.add_component bg_image, Renderable.new(@world.skin, 'startup.png', 1.0, 0, 0)
    @option_entity_manager.add_component bg_image, Position.new(0 ,0)

    lunar_lander = @option_entity_manager.create_tagged_entity 'lunar_lander'
    @option_entity_manager.add_component lunar_lander, Renderable.new(@world.skin, 'lunarlander.png', 1.0, 0, 1)
    x_center = 900 / 2
    y_center = 135
    x =  x_center - (@option_entity_manager.get_component_of_type(lunar_lander, Renderable).width / 2)
    y = y_center - (@option_entity_manager.get_component_of_type(lunar_lander, Renderable).height / 2)
    @option_entity_manager.add_component lunar_lander, Position.new(x, y)

    skin_option = @option_entity_manager.create_tagged_entity 'option'
    @option_entity_manager.add_component skin_option, UserOption.new('world')

    start_option = @option_entity_manager.create_tagged_entity 'option'
    @option_entity_manager.add_component start_option, UserOption.new('start')

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

    @user_option_system.process_one_game_tick @option_entity_manager
    @rendering_system.process_one_game_tick(2, @option_entity_manager, @batch, @font)

    draw_info
    @batch.end

    if Gdx.input.isKeyPressed(Input::Keys::Q)
      @bg_song.stop
      @bg_song.dispose
      Gdx.app.exit
    end

  end

  def draw_info
    @font.draw(@batch, "player 1 controls", 99, 420);
    @font.draw(@batch, "thrust", 130, 382);
    @font.draw(@batch, "s", 145, 366);
    @font.draw(@batch, "a", 139, 355);
    @font.draw(@batch, "turn left", 88, 341);
    @font.draw(@batch, "d", 151, 355);
    @font.draw(@batch, "turns right", 162, 341);

    if @user_option_system.multiplayer
      @font.draw(@batch, "player 2 controls", 699, 420);
      @font.draw(@batch, "thrust", 730, 381);
      @font.draw(@batch, "k", 745, 364);
      @font.draw(@batch, "j", 738, 357);
      @font.draw(@batch, "turn left", 684, 342);
      @font.draw(@batch, "l", 756, 357);
      @font.draw(@batch, "turns right", 764, 345);
    end

    @font.draw(@batch, "P to play!", 8, 100);
    @font.draw(@batch, "w to jump worlds!", 8, 80);
    @font.draw(@batch, "1/2 to choose players", 8, 60);

    if @user_option_system.multiplayer
      @font.draw(@batch,  "multiplayer", 36, 46);
    else
      @font.draw(@batch,  "singleplayer", 29, 46);
    end
    @font.draw(@batch, "Lunar Lander (Q to exit)", 8, 20);
    @font.draw(@batch, "M to mute", 820, 20);
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


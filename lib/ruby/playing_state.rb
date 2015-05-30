java_import com.badlogic.gdx.Screen

require_relative 'lunar_lander_em'

# Necesssary components
require_relative 'components/component'
require_relative 'components/engine'
require_relative 'components/fuel'
require_relative 'components/gravitysensitive'
require_relative 'components/landable'
require_relative 'components/motion'
require_relative 'components/pad'
require_relative 'components/playerinput'
require_relative 'components/polygoncollidable'
require_relative 'components/renderable'
require_relative 'components/solid'
require_relative 'components/spatialstate'

# Necessary systems
require_relative 'systems/asteroidsystem'
require_relative 'systems/collisionsystem'
require_relative 'systems/enginesystem'
require_relative 'systems/inputsystem'
require_relative 'systems/landingsystem'
require_relative 'systems/physics'
require_relative 'systems/renderingsystem'
require_relative 'systems/system'

class PlayingState
  include Screen
  def initialize(game, menu_screen, skin, multiplayer, muted)
    @game = game
    @skin = skin
    @menu_screen = menu_screen
    @bg_song = nil
    @multiplayer = multiplayer
    @muted = muted
  end

  def pick_song()
    case @skin
    when 'firstskin/'
      @bg_song = Gdx.audio.newMusic Gdx.files.internal("res/music/portivolare.mp3")
      @bg_song.setVolume 0.25
    when 'neonskin/'
      @bg_song = Gdx.audio.newMusic Gdx.files.internal("res/music/flux.mp3")
      @bg_song.setVolume 0.85
    when 'solidskin/'
      @bg_song = Gdx.audio.newMusic Gdx.files.internal("res/music/greenbackboogie.mp3")
      @bg_song.setVolume 0.65
    end
  end

  def show
    pick_song()
    #if File.size? 'savedgame.dat'
    #   save_file = File.open( 'savedgame.dat' )
    #  @entity_manager = Marshal::load(save_file)
    #   save_file.close
    #   @entity_manager.game = self
    # else
    @entity_manager = Lunar_lander_em.new @game

    # to go into the World entities component list
    pull = 0.0045 # m/s^2

    ground = @entity_manager.create_tagged_entity 'ground'
    @entity_manager.add_component ground, SpatialState.new(0, 0, 0, 0)
    @entity_manager.add_component ground, Renderable.new(@skin, "ground.png", 1, 0)
    @entity_manager.add_component ground, PolygonCollidable.new

    platformbackground = @entity_manager.create_tagged_entity 'platform_bg'
    @entity_manager.add_component platformbackground, SpatialState.new(150, 145, 0, 0)
    @entity_manager.add_component platformbackground, Renderable.new(@skin, "platformbackground.png", 1.0, 0)
    @entity_manager.add_component platformbackground, Pad.new

    p1_lander = @entity_manager.create_tagged_entity 'p1_lander'
    @entity_manager.add_component p1_lander, SpatialState.new(400, 350, 0, 0)
    @entity_manager.add_component p1_lander, Engine.new(0.01)
    @entity_manager.add_component p1_lander, Fuel.new(250)
    @entity_manager.add_component p1_lander, Renderable.new(@skin, "crashlander1.png", 1.2, 0)
    @entity_manager.add_component p1_lander, PlayerInput.new([Input::Keys::A, Input::Keys::S, Input::Keys::D])
    @entity_manager.add_component p1_lander, GravitySensitive.new(pull)
    @entity_manager.add_component p1_lander, Motion.new
    @entity_manager.add_component p1_lander, PolygonCollidable.new
    @entity_manager.add_component p1_lander, Landable.new

    if @multiplayer
      p2_lander = @entity_manager.create_tagged_entity('p2_lander')
      @entity_manager.add_component p2_lander, SpatialState.new(70, 200, 0, 0)
      @entity_manager.add_component p2_lander, Engine.new(0.025)
      @entity_manager.add_component p2_lander, Fuel.new(100)
      @entity_manager.add_component p2_lander, Renderable.new(@skin, "crashlander2.png", 1.2, 0)
      @entity_manager.add_component p2_lander, PlayerInput.new([Input::Keys::J, Input::Keys::K, Input::Keys::L])
      @entity_manager.add_component p2_lander, Motion.new
      @entity_manager.add_component p2_lander, PolygonCollidable.new
      @entity_manager.add_component p2_lander, Landable.new
    end

    platform = @entity_manager.create_tagged_entity 'platform'
    @entity_manager.add_component platform, SpatialState.new(150, 145, 0, 0)
    @entity_manager.add_component platform, Renderable.new(@skin, "platform.png", 1.0, 0)
    @entity_manager.add_component platform, PolygonCollidable.new
    upper_y = 145 + @entity_manager.get_component_of_type(platform, Renderable).height
    upper_x = 150 + @entity_manager.get_component_of_type(platform, Renderable).width
    @entity_manager.add_component platform, Solid.new(150, upper_x, upper_y)
    # end
    #$logger.debug @entity_manager.dump_details

    # Initialize any runnable systems
    @engine_system      = EngineSystem.new self
    @input_system       = InputSystem.new self
    @physics_system     = Physics.new self
    @rendering_system   = RenderingSystem.new self
    @collision_system   = CollisionSystem.new self
    @landing_system     = LandingSystem.new self
    @asteroid_system    = AsteroidSystem.new self, @skin

    #set background
    @bg_image = Texture.new(Gdx.files.internal("res/images/" + @skin + "background.png"))

    @game_over=false
    # win condition
    @landed=false
    # score and/or such stuff
    @elapsed=0

    # game spesific 'surroundings'
    @camera = OrthographicCamera.new
    @camera.setToOrtho(false, 900, 600);
    @batch = SpriteBatch.new
    @font = BitmapFont.new
    if !@muted
      @bg_song.play
    end
  end

  # Called when this screen is no longer the current screen for a Game.
  def hide
  end

  # Method called by the game loop from the application every time rendering
  # should be performed. Game logic updates are usually also performed in this
  # method.
  def render(gdx_delta)
    #Display.sync(120)
    delta = gdx_delta * 1000

    # Nice because you can dictate the order things are processed
    @asteroid_system.process_one_game_tick(delta, @entity_manager)
    @input_system.process_one_game_tick(delta, @entity_manager)
    @physics_system.process_one_game_tick(delta, @entity_manager)
    @engine_system.process_one_game_tick(delta, @entity_manager)
    @game_over = @collision_system.process_one_game_tick(delta,@entity_manager)
    @landed = @landing_system.process_one_game_tick(delta,@entity_manager)

    # Make sure you "layer" things in here from bottom to top...
    @camera.update
    @batch.setProjectionMatrix(@camera.combined)
    @batch.begin

    @batch.draw(@bg_image, 0, 0)

    @rendering_system.process_one_game_tick(delta, @entity_manager, @camera, @batch, @font)

    # This shows how to do something every N seconds:
    @elapsed += delta;
    if (@elapsed >= 1000)
      @game.increment_game_clock(@elapsed/1000*LunarLanderGame::GAME_CLOCK_MULTIPLIER)
      @elapsed = 0
    end

    @font.draw(@batch, "FPS: #{Gdx.graphics.getFramesPerSecond}", 8, 460);
    @font.draw(@batch, "ESC to exit", 8, 20);
    @font.draw(@batch, "Time now: #{@game.game_clock.to_s}", 8, 50);

    if @landed
      @font.draw(@batch,"Hooray you made it!", 120, 150)
    elsif @game_over
      @font.draw(@batch,"Bang, you're dead!", 120, 150)
    end

    @batch.end

    if Gdx.input.isKeyPressed(Input::Keys::M)
      if @muted
        @bg_song.play
      else
        @bg_song.pause
      end
      @muted = !@muted
    elsif Gdx.input.isKeyPressed(Input::Keys::ESCAPE)
      if !(@game_over || @landed)
        File.open("savedgame.dat", "wb") do |file|
          file.print Marshal::dump(@entity_manager)
        end
      end
      @bg_song.stop
      @bg_song.dispose
      @game.setScreen @menu_screen
    elsif Gdx.input.isKeyPressed(Input::Keys::ENTER)
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
  end
end
java_import com.badlogic.gdx.Screen

require 'lunar_lander_em'
require 'result_screen'

# Necesssary components
require 'components/aerodynamic'
require 'components/animation'
require 'components/collision'
require 'components/component'
require 'components/controls'
require 'components/engine'
require 'components/fuel'
require 'components/gravitysensitive'
require 'components/landable'
require 'components/life'
require 'components/motion'
require 'components/origin'
require 'components/pad'
require 'components/position'
require 'components/renderable'
require 'components/rotation'
require 'components/solid'
require 'components/velocity'

# Necessary systems
require 'systems/collisionsystem'
require 'systems/cleanupasteroidsystem'
require 'systems/controlssystem'
require 'systems/enginesystem'
require 'systems/landingsystem'
require 'systems/makeasteroidsystem'
require 'systems/movementsystem'
require 'systems/musicfadingsystem'
require 'systems/physics'
require 'systems/renderingsystem'
require 'systems/system'

# Helpers
require 'helper/renderinglevels'

class PlayingScreen
  include Screen
  include RenderingLevels
  def initialize(game, menu_screen, world, multiplayer, muted)
    @game = game
    @world = world
    @menu_screen = menu_screen
    @bg_song = @world.music
    @multiplayer = multiplayer
    @muted = muted
  end

  def show
    #if File.size? 'savedgame.dat'
    #   save_file = File.open( 'savedgame.dat' )
    #  @entity_manager = Marshal::load(save_file)
    #   save_file.close
    #   @entity_manager.game = self
    # else
    @entity_manager = Lunar_lander_em.new @game

    add_world_entity_commons

    if @multiplayer
      p2_lander = @entity_manager.create_tagged_entity('p2_lander')
      @entity_manager.add_component p2_lander, Position.new(70, 200)
      @entity_manager.add_component p2_lander, Rotation.new(0.1)
      thrust = 0.01
      @entity_manager.add_component p2_lander, Engine.new(thrust, @world.engine_x, @world.engine_y)
      @entity_manager.add_component p2_lander, Fuel.new(100)
      @entity_manager.add_component p2_lander, Renderable.new(@world.skin, "crashlander2.png", 1.2, 0, self.PLAYER2)
      @entity_manager.add_component p2_lander, Controls.new([Input::Keys::J, Input::Keys::K, Input::Keys::L])
      if @world.has_wind
        @entity_manager.add_component p2_lander, Aerodynamics.new(0.12)
      end
      @entity_manager.add_component p2_lander, Velocity.new
      @entity_manager.add_component p2_lander, Motion.new
      @entity_manager.add_component p2_lander, Collision.new
      @entity_manager.add_component p2_lander, Landable.new
    end

    # end
    #$logger.debug @entity_manager.dump_details

    # Initialize any runnable systems
    @engine_system              = EngineSystem.new self
    @controls_system            = ControlsSystem.new self
    @physics_system             = Physics.new self, @world.gravity_strength
    @movement_system            = MovementSystem.new self
    @rendering_system           = RenderingSystem.new self
    @collision_system           = CollisionSystem.new self
    @landing_system             = LandingSystem.new self
    @make_asteroid_system       = MakeAsteroidSystem.new self, @world
    @cleanup_asteroid_system    = CleanupAsteroidSystem.new self

    #set background
    @bg_image = Texture.new(Gdx.files.internal("res/images/" + @world.skin + "background.png"))

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
    if !@muted && !@bg_song.isPlaying
      @bg_song.play
    end
  end

  def add_world_entity_commons
    ground = @entity_manager.create_tagged_entity 'ground'
    @entity_manager.add_component ground, Position.new(0, 0)
    @entity_manager.add_component ground, Renderable.new(@world.skin, "ground.png", 1, 0, self.GROUND)
    @entity_manager.add_component ground, Collision.new

    platformbackground = @entity_manager.create_tagged_entity 'platform_bg'
    @entity_manager.add_component platformbackground, Position.new(150, 145)
    @entity_manager.add_component platformbackground, Renderable.new(@world.skin, "platformbackground.png", 1.0, 0, self.PLATFORM_BACKGROUND)
    @entity_manager.add_component platformbackground, Pad.new

    p1_lander = @entity_manager.create_tagged_entity 'p1_lander'
    @entity_manager.add_component p1_lander, Position.new(450,450)
    @entity_manager.add_component p1_lander, Rotation.new(0.1)
    thrust = 0.01
    @entity_manager.add_component p1_lander, Engine.new(thrust, @world.engine_x, @world.engine_y)
    @entity_manager.add_component p1_lander, Fuel.new(250)
    @entity_manager.add_component p1_lander, Renderable.new(@world.skin, "crashlander1.png", 1.2, 0, self.PLAYER1)
    @entity_manager.add_component p1_lander, Controls.new([Input::Keys::A, Input::Keys::S, Input::Keys::D])
    if @world.has_gravity
      @entity_manager.add_component p1_lander, GravitySensitive.new
    end
    if @world.has_wind
      @entity_manager.add_component p1_lander, Aerodynamics.new(0.12)
    end
    @entity_manager.add_component p1_lander, Velocity.new
    @entity_manager.add_component p1_lander, Motion.new
    @entity_manager.add_component p1_lander, Collision.new
    @entity_manager.add_component p1_lander, Landable.new

    platform = @entity_manager.create_tagged_entity 'platform'
    @entity_manager.add_component platform, Position.new(150, 145)
    @entity_manager.add_component platform, Renderable.new(@world.skin, "platform.png", 1.0, 0, self.PLATFORM)
    upper_y = 145 + @entity_manager.get_component_of_type(platform, Renderable).height
    upper_x = 150 + @entity_manager.get_component_of_type(platform, Renderable).width
    @entity_manager.add_component platform, Solid.new(150, upper_x, upper_y)
    @entity_manager.add_component platform, Collision.new
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
    @make_asteroid_system.process_one_game_tick(delta, @entity_manager)
    @controls_system.process_one_game_tick(delta, @entity_manager)
    @engine_system.process_one_game_tick(delta, @entity_manager)
    @physics_system.process_one_game_tick(delta, @entity_manager, @movement_system)
    @cleanup_asteroid_system .process_one_game_tick(delta,@entity_manager)
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
      @game.setScreen ResultScreen.new(@game, @menu_screen, @world, @multiplayer, @muted)
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
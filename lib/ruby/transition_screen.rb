java_import com.badlogic.gdx.Screen

require 'lunar_lander_em'

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
require 'components/loop'
require 'components/motion'
require 'components/origin'
require 'components/pad'
require 'components/position'
require 'components/renderable'
require 'components/rotation'
require 'components/solid'
require 'components/velocity'

# Necessary systems
require 'systems/asteroidrotationsystem'
require 'systems/cleanupasteroidsystem'
require 'systems/collisionsystem'
require 'systems/enginesystem'
require 'systems/landingsystem'
require 'systems/makeasteroidsystem'
require 'systems/movementsystem'
require 'systems/musicfadingsystem'
require 'systems/physics'
require 'systems/renderingsystem'
require 'systems/scrollcontrolsystem'
require 'systems/scrollingsystem'
require 'systems/solidscrolleffectsystem'
require 'systems/straighteningsystem'
require 'systems/system'

# Helpers
require 'helper/transitionlevels'

class TransitionScreen
  include Screen
  include TransitionLevels
  def initialize(game, menu_screen, world, multiplayer, muted)
    @game = game
    @world = world
    @menu_screen = menu_screen
    @bg_song = @world.music
    @multiplayer = multiplayer
    @muted = muted
  end

  def show
    @entity_manager = Lunar_lander_em.new @game

    add_transition_world_entity_commons @world.name

    if @multiplayer
      p2_lander = @entity_manager.create_tagged_entity 'p2_lander'
      @entity_manager.add_component p2_lander, Rotation.new(0.04, 12)
      @entity_manager.add_component p2_lander, Position.new(700, 90)
      @entity_manager.add_component p2_lander, Renderable.new(@world.skin, "crashlander2.png", 1, 0, PLAYER2)
      @entity_manager.add_component p2_lander, Controls.new([Input::Keys::J, Input::Keys::L])
      @entity_manager.add_component p2_lander, Velocity.new
      @entity_manager.add_component p2_lander, Motion.new
      @entity_manager.add_component p2_lander, Collision.new
    end

    @controls_system         = ScrollControlSystem.new self, @multiplayer
    @straighten_system       = StraighteningSystem.new self, @multiplayer
    @physics_system          = Physics.new self
    @movement_system         = MovementSystem.new self
    case @world.name
    when 'first'
      @scrolling_system      = ScrollingSystem.new self
    when 'neon'
      @scrolling_system      = ScrollingSystem.new self
    when 'solid'
      @scrolling_system      = SolidScrollEffectSystem.new self, @world, @entity_manager
    else
      @scrolling_system      = ScrollingSystem.new self
    end
    @rendering_system        = RenderingSystem.new self
    @collision_system        = CollisionSystem.new self
    @make_asteroid_system    = MakeAsteroidSystem.new self, @world, true # is transitioning
    @rotate_asteroids_system = AsteroidRotationSystem.new self
    @cleanup_asteroid_system = CleanupAsteroidSystem.new self

    @game_over=false
    @elapsed=0

    # game spesific 'surroundings'
    @camera = OrthographicCamera.new
    @camera.setToOrtho(false, 900, 600); # remember this shitt if it doesn't work
    @batch = SpriteBatch.new
    @font = BitmapFont.new
    if !@muted
      @bg_song.play
    end
  end

  def add_transition_world_entity_commons(world_name)

    #set background
    # TODO this needs to scroll too
    bg_image = @entity_manager.create_tagged_entity 'background'
    @entity_manager.add_component bg_image, Position.new(0, 0) #bottom third covers image
    @entity_manager.add_component bg_image, Renderable.new(@world.skin, "transition.png", 1, 0, BACKGROUND)
    if world_name != 'solid'
      @entity_manager.add_component bg_image, Velocity.new(0,-1) # slow down
      @entity_manager.add_component bg_image, Motion.new
      @entity_manager.add_component bg_image, Loop.new(-600, 0, 1)
    end

    p1_lander = @entity_manager.create_tagged_entity 'p1_lander'
    if @multiplayer
      @entity_manager.add_component p1_lander, Position.new(110, 90)
    else
      @entity_manager.add_component p1_lander, Position.new(420, 90)
    end
    @entity_manager.add_component p1_lander, Rotation.new(0.04, 12)
    @entity_manager.add_component p1_lander, Renderable.new(@world.skin, "crashlander1.png", 1, 0, PLAYER1)
    @entity_manager.add_component p1_lander, Controls.new([Input::Keys::A, Input::Keys::D])
    @entity_manager.add_component p1_lander, Velocity.new
    @entity_manager.add_component p1_lander, Motion.new
    @entity_manager.add_component p1_lander, Collision.new

    if world_name != 'solid'
      scroll_effect = @entity_manager.create_tagged_entity 'scroll_effect'
      @entity_manager.add_component scroll_effect, Position.new(0, 0) #bottom third covers image
      @entity_manager.add_component scroll_effect, Velocity.new(0,-20) # fast down
      @entity_manager.add_component scroll_effect, Renderable.new(@world.skin, "scrolleffect.png", 1, 0, FRONT_SCROLL)
      @entity_manager.add_component scroll_effect, Motion.new
      @entity_manager.add_component scroll_effect, Loop.new(-1200, 0, 7)
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
    @make_asteroid_system.process_one_game_tick(delta, @entity_manager)
    @controls_system.process_one_game_tick(delta, @entity_manager)
    @straighten_system.process_one_game_tick(delta,@entity_manager)
    @physics_system.process_one_game_tick(delta, @entity_manager, @movement_system)
    @scrolling_system.process_one_game_tick(delta, @entity_manager)
    @game_over = @collision_system.process_one_game_tick(delta,@entity_manager)
    @cleanup_asteroid_system.process_one_game_tick(delta, @entity_manager)

    # Make sure you "layer" things in here from bottom to top...
    @camera.update
    @batch.setProjectionMatrix(@camera.combined)
    @batch.begin

    @physics_system.process_one_game_tick(delta,@entity_manager,@movement_system)
    @rotate_asteroids_system.process_one_game_tick(delta, @entity_manager)
    @rendering_system.process_one_game_tick(LEVEL_COUNT, @entity_manager, @batch, @font)

    # This shows how to do something every N seconds:
    @elapsed += delta;
    if (@elapsed >= 1000)
      @game.increment_game_clock(@elapsed/1000*LunarLanderGame::GAME_CLOCK_MULTIPLIER)
      @elapsed = 0
    end

    @font.draw(@batch, "FPS: #{Gdx.graphics.getFramesPerSecond}", 8, 45);
    @font.draw(@batch, "ESC to exit", 8, 20);

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
      @game.setScreen PlayingScreen.new(@game, @menu_screen, @world, @multiplayer, @muted)
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
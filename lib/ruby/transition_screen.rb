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
require 'components/motion'
require 'components/origin'
require 'components/pad'
require 'components/position'
require 'components/renderable'
require 'components/solid'
require 'components/velocity'

# Necessary systems
require 'systems/asteroidsystem'
require 'systems/collisionsystem'
require 'systems/controlssystem'
require 'systems/enginesystem'
require 'systems/landingsystem'
require 'systems/movementsystem'
require 'systems/musicfadingsystem'
require 'systems/physics'
require 'systems/renderingsystem'
require 'systems/system'

# Helpers
require 'helper/renderinglevels'

class TransitionScreen
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

    add_transition_world_entity_commons

    # TODO make this fit
    if false # @multiplayer
      p2_lander = @entity_manager.create_tagged_entity('p2_lander')
      @entity_manager.add_component p2_lander, Position.new(450, 750)
      @entity_manager.add_component p2_lander, Renderable.new(@world.skin, "crashlander2.png", 1.2, 0, self.PLAYER2)
      @entity_manager.add_component p2_lander, Controls.new([Input::Keys::J, Input::Keys::L])
      @entity_manager.add_component p2_lander, Velocity.new
      @entity_manager.add_component p2_lander, Motion.new
      @entity_manager.add_component p2_lander, Collision.new
    end

    @controls_system    = ControlsSystem.new self
    @physics_system     = Physics.new self, @world.gravity_strength
    @movement_system    = MovementSystem.new self
    @rendering_system   = RenderingSystem.new self
    @collision_system   = CollisionSystem.new self
    @asteroid_system    = AsteroidSystem.new self, @world

    #set background
    @bg_image = Texture.new(Gdx.files.internal("res/images/" + @world.skin + "background.png")) # TODO image = transition_bg
    # TODO make a transition foreground to 'scroll' past the background

    @game_over=false
    @elapsed=0

    # game spesific 'surroundings'
    @camera = OrthographicCamera.new
    @camera.setToOrtho(false, 600, 900); # remember this shitt if it doesn't work
    @batch = SpriteBatch.new
    @font = BitmapFont.new
    if !@muted
      @bg_song.play
    end
  end

  def add_transition_world_entity_commons
    p1_lander = @entity_manager.create_tagged_entity 'p1_lander'
    @entity_manager.add_component p1_lander, Position.new(110, 75)
    @entity_manager.add_component p1_lander, Renderable.new(@world.skin, "crashlander1.png", 1.2, 0, self.PLAYER1)
    @entity_manager.add_component p1_lander, Controls.new([Input::Keys::A, Input::Keys::D])
    @entity_manager.add_component p1_lander, Velocity.new
    @entity_manager.add_component p1_lander, Motion.new
    @entity_manager.add_component p1_lander, Collision.new
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
    @controls_system.process_one_game_tick(delta, @entity_manager)
    @physics_system.process_one_game_tick(delta, @entity_manager, @movement_system)
    @game_over = @collision_system.process_one_game_tick(delta,@entity_manager)

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

    @font.draw(@batch, "FPS: #{Gdx.graphics.getFramesPerSecond}", 8, 25);
    @font.draw(@batch, "ESC to exit", 8, 10);

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
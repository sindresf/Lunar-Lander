require_relative 'system'
require_relative 'musicfadingsystem'
require 'transition_screen'
require 'helper/worldmaker'

class UserOptionSystem < System
  WORLD_OPTIONS = ['first', 'solid', 'neon'] # , 'whatever' -world
  PLAYER_OPTIONS = [1,2]

  attr_reader :multiplayer, :fading_dir

  def initialize(game, menu_screen, world, bg_song)
    @last_time = Time.now
    @game = game
    @world_index = 0;
    @world = world
    @menu_screen = menu_screen
    @bg_song = bg_song
    @multiplayer = false
    @music_fading_system = MusicFadingSystem.new @game, bg_song
    @fading_dir = 'no'
  end

  def process_one_game_tick(option_entity_manager)

    consider_press = check_press_time
    should_change_world = false
    if consider_press
      should_change_world = consider_W_press
      consider_1_press
      consider_2_press
      consider_M_press
      consider_P_press
    end

    option_entities = option_entity_manager.get_all_entities_with_component_of_type UserOption
    option_entities.each do |option|
      option_component = option_entity_manager.get_component_of_type(option, UserOption)
      case option_component.property
      when 'world'
        if should_change_world
          @world = next_world option_component
          update_images option_entity_manager
        end
      end
    end
  end

  def check_press_time
    now = Time.now
    wait = now - @last_time
    return wait > 0.15
  end

  def consider_W_press
    if Gdx.input.isKeyPressed(Input::Keys::W)
      @last_time = Time.now
      return true
    end
  end

  def consider_1_press
    if @multiplayer
      if Gdx.input.isKeyPressed(Input::Keys::NUM_1)
        @multiplayer = false
      end
    end
  end

  def consider_2_press
    if !@multiplayer
      if Gdx.input.isKeyPressed(Input::Keys::NUM_2)
        @multiplayer = true
      end
    end
  end

  def consider_P_press
    if Gdx.input.isKeyPressed(Input::Keys::P)
      muted = false
      if @bg_song.isPlaying
        # @music_fading_system.fade_out 2
        @bg_song.pause
        muted = false
      else
        muted = true
      end
      @game.setScreen TransitionScreen.new(@game, @menu_screen, @world, @multiplayer, muted)
    end
  end

  def consider_M_press
    if Gdx.input.isKeyPressed(Input::Keys::M)
      if @bg_song.isPlaying
        @bg_song.pause
      else
        @bg_song.play
      end
      @last_time = Time.now
    end
  end

  def next_world(option)
    @world_index += 1
    if @world_index == WORLD_OPTIONS.length
      @world_index = 0
    end
    @world = WorldMaker.make(WORLD_OPTIONS[@world_index])
  end

  def update_images(option_entity_manager)
    image_entities = option_entity_manager.get_all_entities_with_component_of_type Renderable
    image_entities.each do |option|
      image_component = option_entity_manager.get_component_of_type(option, Renderable)
      image_component.image_path @world.skin
    end
  end
end
require_relative 'system'
require 'playing_state'

class UserOptionSystem < System
  SKIN_OPTIONS = ['firstskin/', 'solidskin/', 'neonskin/']
  PLAYER_OPTIONS = [1,2]

  def initialize(game, menu_screen, skin, bg_song)
    @last_time = Time.now
    @game = game
    @skin_index = 0;
    @skin = skin
    @menu_screen = menu_screen
    @bg_song = bg_song
  end

  def process_one_game_tick(option_entity_manager)
    consider_press = check_press_time
    should_change_skin = false
    if consider_press
      should_change_skin = consider_S_press
      consider_P_press
    end

    option_entities = option_entity_manager.get_all_entities_with_component_of_type UserOption
    option_entities.each do |option|
      option_component = option_entity_manager.get_component_of_type(option, UserOption)
      case option_component.property
      when 'skin'
        if should_change_skin
          @skin = option_component.value
          next_skin option_component
          update_images option_entity_manager
        end
        # when 'start' other things might need this

      end
    end
  end

  def check_press_time
    now = Time.now
    wait = now - @last_time
    return wait > 0.1
  end

  def consider_S_press
    if Gdx.input.isKeyPressed(Input::Keys::S)
      @last_time = Time.now
      return true
    end
  end

  def consider_P_press
    if Gdx.input.isKeyPressed(Input::Keys::P)
      @bg_song.pause
      @last_time = Time.now
      @game.setScreen PlayingState.new(@game, @menu_screen, @skin)
    end
  end

  def next_skin(option)
    @skin_index += 1
    if @skin_index == SKIN_OPTIONS.length
      @skin_index = 0
    end
    @skin = SKIN_OPTIONS[@skin_index]
    option.value = @skin
  end

  def update_images(option_entity_manager)
    image_entities = option_entity_manager.get_all_entities_with_component_of_type Renderable
    image_entities.each do |option|
      image_component = option_entity_manager.get_component_of_type(option, Renderable)
      image_component.image_path @skin
    end
  end
end
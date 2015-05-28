require_relative 'system'
require 'playing_state'

class UserOptionSystem < System
  SKIN_OPTIONS = ['firstskin/', 'solidskin/', 'neonskin/']
  PLAYER_OPTIONS = [1,2]

  def initialize(game, menu_screen, skin, bg_song)
    @last_time = Time.new
    @game = game
    @skin_index = 0;
    @skin = skin
    @menu_screen = menu_screen
    @bg_song = bg_song
  end

  # TODO Time Almost correctly considered (first click hack)
  def process_one_game_tick(option_entity_manager)
    now = Time.new
    wait = now - @last_time
    pressed = false
    if Gdx.input.isKeyPressed(Input::Keys::S)
      @last_time = now
      if wait > 0.1
        pressed = true
      end
    end
    option_entities = option_entity_manager.get_all_entities_with_component_of_type UserOption
    option_entities.each do |option|
      option_component = option_entity_manager.get_component_of_type(option, UserOption)
      if  option_component.property == 'skin'
        if pressed
          @skin = option_component.value
          next_skin option_component
          update_images option_entity_manager
        end
      elsif option_component.property == 'start' && Gdx.input.isKeyPressed(Input::Keys::P)
        @bg_song.pause
        @game.setScreen PlayingState.new(@game, @menu_screen, @skin)
      end
    end

  end

  def next_skin(option)
    @skin = SKIN_OPTIONS[@skin_index]
    option.value = @skin
    @skin_index += 1
    if @skin_index == SKIN_OPTIONS.length
      @skin_index = 0
    end
  end

  def update_images(option_entity_manager)
    image_entities = option_entity_manager.get_all_entities_with_component_of_type Renderable
    image_entities.each do |option|
      image_component = option_entity_manager.get_component_of_type(option, Renderable)
      image_component.image_path @skin
    end
  end
end
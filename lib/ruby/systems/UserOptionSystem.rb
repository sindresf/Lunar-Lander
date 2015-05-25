require_relative 'system'
require 'playing_state'

class UserOptionSystem < System
  SKIN_OPTIONS = ['firstskin/', 'solidskin/', 'neonskin/']
  PLAYER_OPTIONS = [1,2]

  def initialize(game, skin)
    @game = game
    @skin_index = 0;
    @skin = skin
  end

  # TODO make this consider Time, so it doesn't flicker so much!
  def process_one_game_tick(option_entity_manager)
    option_entities = option_entity_manager.get_all_entities_with_component_of_type UserOption
    option_entities.each do |option|
      option_component = option_entity_manager.get_component_of_type(option, UserOption)
      if  option_component.property == 'skin'
        @skin = option_component.value
      end
      if option_component.property == 'skin' && Gdx.input.isKeyPressed(Input::Keys::S)
        puts "WOW, damn"
        next_skin option_component
        update_images option_entity_manager
      elsif option_component.property == 'start' && Gdx.input.isKeyPressed(Input::Keys::P)
        @game.setScreen PlayingState.new(@game, @skin)
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
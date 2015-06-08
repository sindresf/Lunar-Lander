module TransitionLevels
  attr_reader :BACKGROUND, :BG_SCROLL, :BG_OBJECTS, :PLAYER, :FRONT_OBJECTS, :FRONT_SCROLL, :LEVEL_COUNT
  BACKGROUND ||= 0
  BG_SCROLL ||= 1 # just for show
  BG_OBJECTS ||= 2 # interactives
  PLAYER1 ||= 3
  PLAYER2 ||= 4
  FRONT_OBJECTS ||= 5 # interactives
  FRONT_SCROLL ||= 6 # just for show
  LEVEL_COUNT ||= 7
end
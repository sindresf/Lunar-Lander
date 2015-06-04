# Lunar-Lander

###Origins
The tutorial follow-along, and subsequent expansion upon, RECF sample game: [ruby entity component framework](https://github.com/cpowell/ruby-entity-component-framework)

##Features
__Startup Scene__
- [x] create
 - [x] with its own entity manager
 - [x] background graphic
 - [x] title graphic
 - [ ] everything is enteties even here
- [x] buttonsystem considers time between presses
 - [x] for all types of presses
- [x] press 'p' to start game
- [x] press 'w' to cycle through worlds
 - [x] world carries into game scene
 - [ ] set all variables that controls the world's behaviour
- [x] press '1' for single player
- [x] press '2' for multiplayer
- [ ] press 'l' to load previous game
- [x] display both players controls
 - [ ] controls are the user's choice
 - [ ] press 'shift' to enter player control setter mode
- [ ] press 'tab' to view scoreboard
 - [ ] make file-stored scoreboard info
- [x] music in background
 - [x] press 'm' to mute
 - [ ] fade to game music

__Game Scene__
- [x] create
 - [x] background graphic
 - [x] player 1 and 2 graphics
 - [x] asteroid graphic
   - [ ] randomly pick from several asteroid graphics
    - [x] rotates based on latitudinal direction and speed
    - [x] comes from the sides specified by the world
    - [ ] make_background_asteroids
 - [x] platform graphic
 - [x] platform stops player when landed
 - [x] platform backgroun graphic
 - [x] ground graphics
 - [x] worlds
    - [ ] updated graphics
    - [x] skins made into worlds
    - [ ] different behaviour and gameplay for worlds
- [x] controls for both players
 - [x] fuel consideration
 - [x] slight difference in gameplay
 - [ ] can choose player_lander in singleplayer mode
- [x] collision detection
 - [ ] upgraded detection algorithm
- [x] asteroids creation
 - [x] asteroids removal
   - [x] off screen
   - [x] hitting ground
 - [x] asteroids from all sides
 - [ ] upgraded creation algorithm
- [ ] wind effect
- [ ] player life points 
- [ ] animations
 - [ ] effect on collision
 - [ ] effect on fuel burning
- [x] music in background
 - [x] background song based on skin
 - [ ] fade out to menu music on quit
- [ ] sounds
 - [ ] for engine on
 - [ ] for collision
 - [ ] for dying
 - [ ] for landing

__Transition Scene__
- [x] create
- [x] music in background
 - [x] same as 'world'
 - [ ] carries over into game
- [ ] make a up-scroller for world transition 
 - [x] scrolling background
 - [x] scrolling effect
   - [ ] looping scrolling
 - [ ] its own controls
 - [ ] scoring that goes into gaming
 - [ ] rename the project "**Intergalactic whatnots**" at this point

__Win/loss Scene__
- [x] create
 - [ ] type in score name for scoreboard
- [ ] scoring
 - [ ] consider: time
 - [ ] consider: fuel left
 - [ ] consider: *who* for multiplayer
 - [ ] consider: life left

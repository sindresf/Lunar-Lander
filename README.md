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
- [x] press 's' to cycle through skins
 - [x] skin carries into game scene
 - [ ] set all variables that controls the skins behaviour
- [x] press '1' for single player
- [x] press '2' for multiplayer
- [ ] press 'l' to load previous game
- [x] display both players controls
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
    - [x] rotates based on latitudinal direction and speed
 - [ ] randomly pick from several asteroid graphics
 - [x] platform graphic
 - [x] platform stops player when landed
 - [x] platform backgroun graphic
 - [x] ground graphics
 - [x] skins
    - [ ] updated graphics
    - [ ] skins made into worlds
    - [ ] different behaviour and gameplay for worlds
- [x] controls for both players
 - [x] fuel consideration
 - [x] slight difference in gameplay
- [x] collision detection
 - [ ] upgraded detection algorithm
- [x] asteroids creation
 - [x] asteroids removal
   - [x] off screen
   - [x] hitting ground
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
- [ ] create
- [ ] music in background
 - [ ] same as startup screen *or* 'world' specific 
- [ ] make a up-scroller for world transition 
 - [ ] rename the project "**Intergalactic whatnots**" at this point

__Win/loss Scene__
- [ ] create
 - [ ] type in score name for scoreboard
- [ ] scoring
 - [ ] consider: time
 - [ ] consider: fuel left
 - [ ] consider: *who* for multiplayer
 - [ ] consider: life left

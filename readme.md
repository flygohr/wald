Missing game description

### Credits:
- Font: https://fontesk.com/bubble-sans-font/, https://www.1001fonts.com/libre-baskerville-font.html
- HTML5 File Dialog plugin: https://gitlab.com/mocchapi/godot-4-html5-file-dialogs

### To-do:
- [x] De-couple map generation from map visualization, and speed it up
	- [x] Instead of a thousand attempts, run a ray around the points to find a suitable point, increments of 5 degrees
- [x] Visualize the map with a simple script that reads the object and displays points in various colors
- [x] Create a camera to pan around the map, zoom in, zoom out
	- [ ] Fix its center function, add new panning option with starting and ending parameters
- [x] Save and load the generated map as JSON objects
- [x] Fix import and export save to use new functions
- [x] Make a "map navigator" object that can jump around the various nodes at a certain distance from it
	- [x] Save and load its position
- [x] Add arrow pointing towards "exit", but this should maybe part of each node behavior. if exit, display arrow. or for the camera?
- [x] Fix settings screen not showing
	- [x] Make it also the pause menu, with back to game / back to title
- [x] Arc drawings around map nodes need better organization to not overlap and be easily manageable with a few variables at the top
- [ ] Make settings screen a standalone scene capable of reminding what part of the game you were into, if title, wald, or current node screen
- [ ] Write all the prompts and texts, start making it a real adventure
- [ ] Write copy for characters
- [ ] Draw waypoint sprite
- [ ] Draw character sprites
- [ ] Draw all the action icons
- [ ] Draw all the backgrounds
- [ ] Draw all the map features
- [ ] Implement soundscapes
- [ ] Add "recap" screen for prompts: you gained / you lost summary before resuming gameplay

### Bugs and fixes:
- [x] Waypoint marker doesn't take into account camera limits
- [x] Fix clunky camera drag code
- [x] Selection outline wrong color sometimes
- [x] Change to a font that supports the "-" character
- [x] Changing scene in the overworld leaves the buttons visible?
- [ ] Disable double click when panning camera
- [ ] 

### Devlog:
- 2026-10-20
	- started thinking about map generation
- 2026-10-22
	- cleaned up code, started thinking about camera and save states
- 2026-10-29
	- map navigation almost done, time to think about proper mechanics and MVP
- 2026-11-27
	- reminded myself to keep a devlog
	- won't finish on time and that's fine. still sad
	- mechanics are almost all in place, missing art, sounds, and ALL the prompts
	

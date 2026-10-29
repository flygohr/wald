Description

### Credits:
- Font: https://www.1001fonts.com/komika-font.html, https://www.1001fonts.com/komika-axis-font.html, https://www.1001fonts.com/libre-baskerville-font.html
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
- [ ] Arc drawings around map nodes need better organization to not overlap and be easily manageable with a few variables at the top
- [ ] Make settings screen a standalone scene capable of reminding what part of the game you were into, if title, wald, or current node screen

### Bugs and fixes:
- [ ] Waypoint marker doesn't take into account camera limits
- [ ] Selection outline wrong color sometimes

### Devlog:
- 2026-10-20
	- started thinking about map generation
- 2026-10-22
	- cleaned up code, started thinking about camera and save states
- 2026-10-29
	- map navigation almost done, time to think about proper mechanics and MVP

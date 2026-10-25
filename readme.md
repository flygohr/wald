Description

### Credits:
- Font: https://www.1001fonts.com/komika-font.html, https://www.1001fonts.com/komika-axis-font.html
- HTML5 File Dialog plugin: https://gitlab.com/mocchapi/godot-4-html5-file-dialogs

### To-do:
- [x] De-couple map generation from map visualization, and speed it up
	- [x] Instead of a thousand attempts, run a ray around the points to find a suitable point, increments of 5 degrees
- [x] Visualize the map with a simple script that reads the object and displays points in various colors
- [x] Create a camera to pan around the map, zoom in, zoom out
	- [ ] Fix its center function, add new panning option with starting and ending parameters
- [x] Save and load the generated map as JSON objects
- [ ] Fix import and export save to use new functions
- [ ] Make a "map navigator" object that can jump around the various nodes at a certain distance from it
	- [ ] Save and load its position
- [ ] Add arrow pointing towards "exit", but this should maybe part of each node behavior. if exit, display arrow. or for the camera?
- [ ] Fix settings screen not showing
	- [ ] Make it also the pause menu, with back to game / back to title

### Devlog:
- 2026-10-20
	- started thinking about map generation
- 2026-10-22
	- cleaned up code, started thinking about camera and save states

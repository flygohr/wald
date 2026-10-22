Description

### Credits:
- Font: https://www.1001fonts.com/libre-baskerville-font.html
- HTML5 File Dialog plugin: https://gitlab.com/mocchapi/godot-4-html5-file-dialogs

### To-do:
- [x] De-couple map generation from map visualization, and speed it up
	- [x] Instead of a thousand attempts, run a ray around the points to find a suitable point, increments of 5 degrees
- [x] Visualize the map with a simple script that reads the object and displays points in various colors
- [ ] Create a camera to pan around the map, zoom in, zoom out
- [ ] Make a "map navigator" object that can jump around the various nodes at a certain distance from it
- [ ] Save and load the generated map as JSON objects
	- [ ] Save the "map navigator" current position AKA current node
- [ ] Add arrow pointing towards "exit"

### Devlog:
- 2026-10-20
	- started thinking about map generation
- 2026-10-22
	- cleaned up code, started thinking about camera and save states

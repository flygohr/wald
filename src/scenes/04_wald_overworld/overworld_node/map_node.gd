extends Node2D

#TODO: node needs to do different things depending on what it is
# if revealed, show icon, not general white dot
# if highlighted, show highlight animation
# if end, show finish arrow and offscreen indicator

@export var color : Color
@export var node_radius := 25
@export var dashed_line_scene: PackedScene
@export var navigator_scene: PackedScene

var temporary_dashed_line: Line2D

const COLOR_START: Color = Color.GREEN
const COLOR_FINISH: Color = Color.BLUE

const COLOR_DEFAULT: Color = Color.WEB_GRAY

const COLOR_OBSTACLE: Color = Color.DARK_RED
const COLOR_SOLUTION: Color = Color.ORANGE
const COLOR_EVENT: Color = Color.WEB_PURPLE

@onready var check_button: TextureButton = $CheckButton
@onready var active_marker: Sprite2D = $ActiveMarker


var index: int = 0
var is_active: bool = false:
	set(value):
		is_active = value
		display_active_marker(value)
		queue_redraw()

var is_selected: bool = false:
	set(value):
		is_selected = value
		queue_redraw()

var active_radius: int = 40

var selected_radius: int:
	set(value):
		selected_radius = value
		queue_redraw()

var _time: float = 0

var current_color: Color:
	set(value):
		current_color = value
		queue_redraw()

var is_cleared: bool = false:
	set(value):
		is_cleared = value
		queue_redraw()
		
var is_visited: bool = false:
	set(value):
		is_visited = value
		queue_redraw()


var is_finish: bool = false:
	set(value):
		is_finish = value
		queue_redraw()

var finish_radius: int

var incoming_is_cleared: bool = true:
	set(value):
		incoming_is_cleared = value
		queue_redraw()

func _ready() -> void:
	SignalBus.new_active_node_set.connect(_check_if_active)
	SignalBus.moved_around_the_map.connect(_unselect_this)
	SignalBus.traveled_to.connect(_check_if_traveled_to)
	SignalBus.node_selected.connect(_check_if_still_selected)
	var button_size = (node_radius * 2) + 10
	check_button.size = Vector2(button_size, button_size)
	check_button.position = Vector2(-(button_size/2), -(button_size/2))
	current_color = COLOR_DEFAULT


func _process(delta: float) -> void:

	selected_radius = remap(sin(_time * TAU), -1.0, 1.0, node_radius+20, node_radius+40)

	finish_radius = remap(sin(_time * TAU), -1.0, 1.0, node_radius+10, node_radius+30)
		
	_time += delta


func _draw() -> void:
	draw_circle(
		Vector2.ZERO, 
		node_radius, 
		current_color, 
		true, 
		-1.0, 
		true)
	
	if is_selected and is_active == false and incoming_is_cleared == true:
		draw_circle(Vector2.ZERO, selected_radius, Color.WHITE, false, 5, false)
	elif is_selected and is_active == false and incoming_is_cleared == false:
		draw_circle(Vector2.ZERO, selected_radius, Color.RED, false, 5, false)
	
	if is_cleared == false and is_visited == true:
		draw_circle(Vector2.ZERO, 30, Color.RED, false, 3, false)	
	elif is_cleared == true and is_visited == true:
		draw_circle(Vector2.ZERO, 30, Color.GREEN, false, 3, false)
		
	if is_active:
		draw_circle(Vector2.ZERO, active_radius, Color.WHITE, false, 5, false)
	
	if is_finish:
		draw_circle(Vector2.ZERO, finish_radius, Color.BLUE, false, 5, false)
	
func display_active_marker(toggle: bool) -> void:
	if toggle == true:
		active_marker.show()
	else:
		active_marker.hide()

# TODO: if finish type, add red target marker, and arrow pointing
# TODO: instead of instantly teleport, display a popup with a button asking if move or not, showing cost of travel
# TODO: add dotted line between two cleared points
# TODO: add button to clear node
# TODO: draw another line, a full one, to mark completed connections instead of just dotted line
# TODO: node icon will also be modulated to greyscale if not yet completed
# TODO: icon has two layers. icon on top, always color or question mark. bg is like tokens for vtt, same edge, but inside is green for cleared, red for not cleared, grey for undiscovered


func _check_if_active(i) -> void:
	if i == index:
		is_active = true
	else:
		is_active = false
		queue_redraw()


func update_color(type: String) -> void:
	match type:
		GameData.KEY_MAPNODETYPE_START:
			current_color = COLOR_START
		GameData.KEY_MAPNODETYPE_FINISH:
			current_color = COLOR_FINISH
			is_finish = true #FIXME: I know this is in the wrong place
			var navigator = navigator_scene.instantiate()
			add_child(navigator)
		GameData.KEY_MAPNODETYPE_OBSTACLE:
			current_color = COLOR_OBSTACLE
		GameData.KEY_MAPNODETYPE_SOLUTION:
			current_color = COLOR_SOLUTION
		GameData.KEY_MAPNODETYPE_EVENT:
			current_color = COLOR_EVENT
		_:
			current_color = COLOR_DEFAULT


func _on_check_button_pressed() -> void:
	# Check if is close enough to the active node
	if global_position.distance_to(GameData.current[GameData.KEY_MAP_NODES_DATA][GameData.current[GameData.KEY_MAP_CURRENT_NODE_INDEX]][GameData.KEY_MAPNODE_POS]) <= GameData.current[GameData.KEY_CURRENT_WALKING_DISTANCE] + 50:
		_select_this()

func _check_if_traveled_to(from: int, to: int) -> void:
	if to == index:
		is_active = true
		_erase_temporary_line()
		is_selected = false
		# TEMPORARY CLEARED CHECK
		# TODO: move to scene node
		
		if is_visited == false:
			var cleared_roll: float = randf()
			if cleared_roll > 0.3:
				is_cleared = true
				GameData.current[GameData.KEY_MAP_NODES_DATA][to][GameData.KEY_IS_CLEARED] = true
				
		
		is_visited = true
		GameData.current[GameData.KEY_MAP_NODES_DATA][to][GameData.KEY_IS_VISITED] = true
		GameData.current[GameData.KEY_MAP_NODES_DATA][to][GameData.KEY_INCOMING_CONNECTIONS].append(from)


func _check_if_still_selected(i: int) -> void:
	if i != index: _unselect_this()


func _select_this() -> void:
	SignalBus.pan_to.emit(global_position)
	if GameData.current[GameData.KEY_MAP_NODES_DATA][GameData.current[GameData.KEY_MAP_CURRENT_NODE_INDEX]][GameData.KEY_IS_CLEARED] == false and GameData.current[GameData.KEY_MAP_NODES_DATA][GameData.current[GameData.KEY_MAP_CURRENT_NODE_INDEX]][GameData.KEY_INCOMING_CONNECTIONS].has(index) == false:
		_draw_temporary_line(GameData.current[GameData.KEY_MAP_NODES_DATA][GameData.current[GameData.KEY_MAP_CURRENT_NODE_INDEX]][GameData.KEY_MAPNODE_POS], global_position, false)
		#TODO: if in incoming connections, allow it
	else: _draw_temporary_line(GameData.current[GameData.KEY_MAP_NODES_DATA][GameData.current[GameData.KEY_MAP_CURRENT_NODE_INDEX]][GameData.KEY_MAPNODE_POS], global_position, true)
	is_selected = true
	SignalBus.node_selected.emit(index)

func _unselect_this() -> void:
	is_selected = false
	_erase_temporary_line()


func _draw_temporary_line(s: Vector2, e: Vector2, valid: bool = false) -> void:
	temporary_dashed_line = dashed_line_scene.instantiate()
	temporary_dashed_line.add_point(s)
	temporary_dashed_line.add_point(e)
	add_child(temporary_dashed_line)
	if valid == false:
		temporary_dashed_line.render_not_valid()
		incoming_is_cleared = false
	temporary_dashed_line.global_position = Vector2.ZERO


func _erase_temporary_line() -> void:
	if temporary_dashed_line != null:
		temporary_dashed_line.queue_free()

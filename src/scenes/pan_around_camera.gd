# https://github.com/Eranot/schemer/blob/main/scene/screen/main/main_camera.gd

extends Camera2D

@export var min_zoom := 0.3
@export var max_zoom := 1.0
@export var zoom_factor := 0.1
@export var zoom_duration := 0.2

@export var camera_padding := 400

var zoom_level: float = 0.5
var position_before_drag
var position_before_drag2


func _ready():
	SignalBus.finished_generating_map.connect(_set_limits)
	# center on current node
	# GlobalEvents.center_camera.connect(center_on_tables)


func _unhandled_input(event):
	if event.is_action_pressed("zoom_in"):
		set_zoom_level(zoom_level + zoom_factor)
	elif event.is_action_pressed("zoom_out"):
		set_zoom_level(zoom_level - zoom_factor)
	elif event.is_action_pressed("camera_drag"):
		position_before_drag = event.global_position
		position_before_drag2 = self.global_position
	elif event.is_action_released("camera_drag"):
		position_before_drag = null
	elif event is InputEventPanGesture:
		self.global_position += event.delta * 20
	elif event is InputEventScreenDrag:
		self.global_position -= event.relative
	elif event is InputEventMagnifyGesture:
		if event.factor > 1:
			set_zoom_level(zoom_level + (zoom_factor * 0.5))
		elif event.factor < 1:
			set_zoom_level(zoom_level - (zoom_factor * 0.5))
	
	if position_before_drag and event is InputEventMouseMotion:
		self.global_position = position_before_drag2 + (position_before_drag - event.global_position) * (1/zoom_level)


func set_zoom_level(level: float, mouse_world_position = self.get_global_mouse_position()):
	var old_zoom_level = zoom_level
	
	zoom_level = clampf(level, min_zoom, max_zoom)
	
	var direction = (mouse_world_position - self.global_position)
	var new_position = self.global_position + direction - ((direction) / (zoom_level/old_zoom_level))
	
	self.zoom = Vector2(zoom_level, zoom_level)
	self.global_position = new_position

func _set_limits(list: Array) -> void:
	var top_bound: int = 0
	var right_bound: int = 0
	var bottom_bound: int = 0
	var left_bound: int = 0
	
	for node in list:
		if node[Definitions.KEY_MAPNODE_POS].y < top_bound: top_bound = node[Definitions.KEY_MAPNODE_POS].y
		if node[Definitions.KEY_MAPNODE_POS].x > right_bound: right_bound = node[Definitions.KEY_MAPNODE_POS].x
		if node[Definitions.KEY_MAPNODE_POS].y > bottom_bound: bottom_bound = node[Definitions.KEY_MAPNODE_POS].y
		if node[Definitions.KEY_MAPNODE_POS].x < left_bound: left_bound = node[Definitions.KEY_MAPNODE_POS].x
		
	limit_enabled = true
	
	var extended_top_bound: int = top_bound - camera_padding
	var extended_right_bound: int = right_bound + camera_padding
	var extended_bottom_bound: int = bottom_bound + camera_padding
	var extended_left_bound: int = left_bound - camera_padding
	
	limit_top = extended_top_bound
	limit_right = extended_right_bound
	limit_bottom = extended_bottom_bound
	limit_left = extended_left_bound
	
	SignalBus.generated_map_limits.emit( # Send the map limits to the map visualizer
		extended_left_bound, 
		extended_top_bound, 
		abs(extended_left_bound) + abs(extended_right_bound), 
		abs(extended_top_bound) + abs(extended_bottom_bound)
		)

#TODO: pan from endpoint

	
func center_on_tables():
	var tables: Array[Node] = get_tree().get_nodes_in_group("tables")
	
	var max_x = tables[0].global_position.x + tables[0].size.x
	var min_x = tables[0].global_position.x
	var max_y = tables[0].global_position.y + tables[0].size.y
	var min_y = tables[0].global_position.y
	
	for table in tables:
		max_x = max(max_x, table.global_position.x + table.size.x)
		min_x = min(min_x, table.global_position.x)
		max_y = max(max_y, table.global_position.y + table.size.y)
		min_y = min(min_y, table.global_position.y)
	
	var center = Vector2((max_x - min_x) / 2 + min_x, (max_y - min_y) / 2 + min_y)
	global_position = center
	
	# Find out the zoom
	var screen_width = get_viewport().get_visible_rect().size.x
	var project_width = max_x - min_x + 300
	
	if project_width > screen_width:
		var new_zoom_level = screen_width/project_width
		set_zoom_level(new_zoom_level, global_position)

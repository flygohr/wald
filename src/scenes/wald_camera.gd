extends Camera2D

@export var min_zoom := 1.0
@export var max_zoom := 3.0

@export var limits_offset := 400

@export var zoom_factor := 0.1
@export var zoom_duration := 0.2

var _zoom_level := 2.0

func _ready() -> void:
	SignalBus.finished_generating_map.connect(_calculate_limits)
	zoom = Vector2(_zoom_level, _zoom_level)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			position -= event.relative * zoom
			
	if event.is_action_pressed("zoom_in"):
		_set_zoom_level(_zoom_level + zoom_factor)
	
	if event.is_action_pressed("zoom_out"):
		_set_zoom_level(_zoom_level - zoom_factor)
		
func _set_zoom_level(value: float) -> void:
	_zoom_level = clamp(value, min_zoom, max_zoom)
	zoom = Vector2(_zoom_level, _zoom_level)

	
func _calculate_limits(list: Array) -> void:
	print("Setting camera limits")
	var leftmost_x := 0
	var topmost_y := 0
	var rightmost_x := 0
	var bottomest_y := 0
	
	for node in list:
		if node[Definitions.KEY_MAPNODE_POS].x < leftmost_x:
			leftmost_x = abs(node[Definitions.KEY_MAPNODE_POS].x)
			
		if node[Definitions.KEY_MAPNODE_POS].x > rightmost_x:
			rightmost_x = abs(node[Definitions.KEY_MAPNODE_POS].x)
			
		if node[Definitions.KEY_MAPNODE_POS].y > topmost_y:
			topmost_y = abs(node[Definitions.KEY_MAPNODE_POS].y)
			
		if node[Definitions.KEY_MAPNODE_POS].y < bottomest_y:
			bottomest_y = abs(node[Definitions.KEY_MAPNODE_POS].y)
			
	limit_left = leftmost_x - limits_offset
	limit_right = rightmost_x + limits_offset
	limit_top = -topmost_y - limits_offset
	limit_bottom = bottomest_y + limits_offset

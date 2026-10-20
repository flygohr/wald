extends Camera2D

@export var min_zoom := 0.5
@export var max_zoom := 2.0

@export var zoom_factor := 0.1
@export var zoom_duration := 0.2

var _zoom_level := 0.3

func _ready() -> void:
	zoom = Vector2(_zoom_level, _zoom_level)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			position -= event.relative
			
	if event.is_action_pressed("zoom_in"):
		_set_zoom_level(_zoom_level + zoom_factor)
	
	if event.is_action_pressed("zoom_out"):
		_set_zoom_level(_zoom_level - zoom_factor)
		
func _set_zoom_level(value: float) -> void:
	_zoom_level = clamp(value, min_zoom, max_zoom)
	
	var tween = get_tree().create_tween()
	tween.tween_property(
		self,
		"zoom",
		Vector2(_zoom_level, _zoom_level),
		zoom_duration).set_trans(tween.EASE_OUT)
	

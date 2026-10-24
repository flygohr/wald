extends Node2D

var current_walking_distance := GameData.SHORT_WALK_DISTANCE + 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.debug_travel.connect(move_marker)

func _draw() -> void:
	draw_arc(global_position, current_walking_distance, 0, 360, 100, Color.LIGHT_BLUE, 3, true)
	

func move_marker(coords: Vector2) -> void:
	if coords.distance_to(global_position) < current_walking_distance:
		global_position = coords

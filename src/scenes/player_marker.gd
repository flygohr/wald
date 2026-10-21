extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.debug_travel.connect(move_marker)

func move_marker(coords: Vector2) -> void:
	global_position = coords

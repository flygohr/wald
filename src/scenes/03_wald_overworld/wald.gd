extends Node2D

# This is the map screen of the game. It loads a map from the GameData, and visualizes it with its
# connections and stuff

func _ready() -> void:
	SignalBus.pause_map.connect(_pause_map)


func _pause_map(toggle: bool) -> void:
	if toggle == true:
		for child in get_children():
			child.process_mode = Node.PROCESS_MODE_DISABLED
	else:
		for child in get_children():
			child.process_mode = Node.PROCESS_MODE_INHERIT
		

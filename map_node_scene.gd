extends Node2D

var node_data: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get active node data
	node_data = GameData.current[GameData.KEY_MAP_NODES_DATA][GameData.current[GameData.KEY_MAP_CURRENT_NODE_INDEX]]

extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	size.x = (GameData.current[GameData.KEY_MAP_BOUNDARIES][GameData.KEY_LEFT_X] + GameData.current[GameData.KEY_MAP_BOUNDARIES][GameData.KEY_RIGHT_X])
	size.y = (GameData.current[GameData.KEY_MAP_BOUNDARIES][GameData.KEY_TOP_Y] + GameData.current[GameData.KEY_MAP_BOUNDARIES][GameData.KEY_BOTTOM_Y])
	
	position.x = GameData.current[GameData.KEY_MAP_BOUNDARIES][GameData.KEY_LEFT_X]
	position.y = GameData.current[GameData.KEY_MAP_BOUNDARIES][GameData.KEY_TOP_Y]

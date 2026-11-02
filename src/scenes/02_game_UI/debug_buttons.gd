extends Control


func _ready() -> void:
	if GameData.is_debug == true:
		if GameData.is_inside_node == true:
			show()
		elif GameData.is_inside_node == false:
			hide()

func _on_clear_button_pressed() -> void:
	print_debug("Node has been cleared")
	Gameplay.update_node_status(GameData.current[GameData.KEY_MAP_CURRENT_NODE_INDEX], true)


func _on_reset_button_pressed() -> void:
	print_debug("Node has been blocked")
	Gameplay.update_node_status(GameData.current[GameData.KEY_MAP_CURRENT_NODE_INDEX], false)


func _on_decrease_distance_button_pressed() -> void:
	var distance_values: Array = [
		GameData.SHORT_WALK_DISTANCE, GameData.MEDIUM_WALK_DISTANCE, GameData.LONG_WALK_DISTANCE
	]
	
	var current_distance: int = GameData.current[GameData.KEY_CURRENT_WALKING_DISTANCE]
	
	var current_distance_index: int = distance_values.find(current_distance)
	
	match current_distance_index:
		0:
			pass
		1:
			Gameplay.update_walking_distance(GameData.SHORT_WALK_DISTANCE)
		2:
			Gameplay.update_walking_distance(GameData.MEDIUM_WALK_DISTANCE)
			
	print_debug("Decreasing walking distance")


func _on_increase_distance_button_pressed() -> void:
	var distance_values: Array = [
		GameData.SHORT_WALK_DISTANCE, GameData.MEDIUM_WALK_DISTANCE, GameData.LONG_WALK_DISTANCE
	]
	
	var current_distance: int = GameData.current[GameData.KEY_CURRENT_WALKING_DISTANCE]
	
	var current_distance_index: int = distance_values.find(current_distance)
	
	match current_distance_index:
		0:
			Gameplay.update_walking_distance(GameData.MEDIUM_WALK_DISTANCE)
		1:
			Gameplay.update_walking_distance(GameData.LONG_WALK_DISTANCE)
		2:
			pass
			
	print_debug("Increasing walking distance")


func _on_decrease_sanity_button_pressed() -> void:
	Gameplay.update_sanity(-10)


func _on_increase_sanity_button_pressed() -> void:
	Gameplay.update_sanity(+10)


func _on_decrease_food_button_pressed() -> void:
	Gameplay.update_food(-10)


func _on_increase_food_button_pressed() -> void:
	Gameplay.update_food(+10)


func _on_decrease_karma_button_pressed() -> void:
	Gameplay.update_karma(-10)


func _on_increase_karma_button_pressed() -> void:
	Gameplay.update_karma(+10)


func _on_decrease_loot_button_pressed() -> void:
	Gameplay.update_loot(-10)


func _on_increase_loot_button_pressed() -> void:
	Gameplay.update_loot(+10)

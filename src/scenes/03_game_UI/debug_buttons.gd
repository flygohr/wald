extends Control


func _on_clear_button_pressed() -> void:
	GameData.current[GameData.KEY_MAP_NODES_DATA][GameData.current[GameData.KEY_MAP_CURRENT_NODE_INDEX]][GameData.KEY_IS_CLEARED] = true
	GameData.initiate_save_game_data()


func _on_reset_button_pressed() -> void:
	GameData.current[GameData.KEY_MAP_NODES_DATA][GameData.current[GameData.KEY_MAP_CURRENT_NODE_INDEX]][GameData.KEY_IS_CLEARED] = false
	GameData.initiate_save_game_data()

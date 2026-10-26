extends Node2D

# This is the map screen of the game. It loads a map from the GameData, and visualizes it with its
# connections and stuff


func _on_main_menu_button_pressed() -> void:
	ScenesManager.load_scene(ScenesManager.SCENE_PATHS[ScenesManager.KEY_TITLE_SCREEN])


func _on_options_button_pressed() -> void:
	Settings.transition_in()

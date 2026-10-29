extends CanvasLayer

#TODO: tweak UI depending on current scene, if wald or local

func _on_quit_button_pressed() -> void:
	ScenesManager.load_scene(ScenesManager.SCENE_PATHS[ScenesManager.KEY_TITLE_SCREEN])


func _on_menu_button_pressed() -> void:
	Settings.transition_in()

extends Node2D

const INITIAL_SCENE: StringName = ScenesManager.SCENE_PATHS[ScenesManager.KEY_GAME_SCREEN]
const SETTINGS_SCENE: StringName = ScenesManager.SCENE_PATHS[ScenesManager.KEY_SETTINGS_SCREEN]

@onready var continue_button: Button = $CanvasLayer/VBoxContainer/ContinueButton
@onready var new_game_button: Button = $CanvasLayer/VBoxContainer/NewGameButton

func _ready() -> void:	
	GameData.is_in_game = false
	
	if GameData.current[GameData.KEY_IS_NEW_GAME] == true:
		continue_button.hide()
	else: 
		continue_button.show()


func _on_new_game_button_pressed() -> void:
	# TODO: Replace with game reset prompts
	ScenesManager.load_scene(INITIAL_SCENE)


func _on_continue_button_pressed() -> void:
	ScenesManager.load_scene(INITIAL_SCENE)


func _on_options_button_pressed() -> void:
	# TODO: Fix this scene not displaying anything
	ScenesManager.load_scene(SETTINGS_SCENE)

extends Node2D

const INITIAL_SCENE: StringName = ScenesManager.SCENE_PATHS[ScenesManager.KEY_GAME_SCREEN]
const SETTINGS_SCENE: StringName = ScenesManager.SCENE_PATHS[ScenesManager.KEY_SETTINGS_SCREEN]

@onready var play_button: Button = $CanvasLayer/MarginContainer/VBoxContainer/PlayButton

func _ready() -> void:	
	GameData.is_in_game = false
	
	if (GameData.current[GameData.KEY_IS_NEW_GAME]) == true:
		play_button.text = "NEW GAME"
	else: play_button.text = "CONTINUE"

func _on_play_button_pressed() -> void:
	ScenesManager.load_scene(INITIAL_SCENE)

func _on_options_button_pressed() -> void:
	ScenesManager.load_scene(SETTINGS_SCENE)

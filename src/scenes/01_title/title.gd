extends Node2D

const INITIAL_SCENE: StringName = ScenesManager.SCENE_PATHS[ScenesManager.KEY_OVERWORLD_SCREEN]
const SETTINGS_SCENE: StringName = ScenesManager.SCENE_PATHS[ScenesManager.KEY_SETTINGS_SCREEN]
const GAME_ENDED_SCENE: StringName = ScenesManager.SCENE_PATHS[ScenesManager.KEY_GAME_END_SCREEN]

@onready var continue_button: Button = $CanvasLayer/VBoxContainer/ContinueButton
@onready var new_game_button: Button = $CanvasLayer/VBoxContainer/NewGameButton

func _ready() -> void:
	GameData.is_inside_node = false
	
	if GameData.current[GameData.KEY_IS_NEW_GAME] == true:
		continue_button.hide()
	else: 
		continue_button.show()


func _on_continue_button_pressed() -> void:
	if GameData.current[GameData.KEY_IS_GAME_ENDED] == true:
		ScenesManager.load_scene(GAME_ENDED_SCENE)
	else: ScenesManager.load_scene(INITIAL_SCENE)


func _on_new_game_button_pressed() -> void:
	if (GameData.current[GameData.KEY_IS_NEW_GAME] == false):
		PopupManager.show_popup_confirmation("Starting a new game will erase your current progress.\n\nAre you sure?")
		await PopupManager.yes_button_pressed
		var game_number = GameData.current[GameData.KEY_GAMES_PLAYED]+1
		GameData.current = GameData.DEFAULT_GAME_DATA.duplicate_deep()
		GameData.current[GameData.KEY_GAMES_PLAYED] = game_number
		GameData.initiate_save_game_data()
		ScenesManager.load_scene(INITIAL_SCENE)
	else: ScenesManager.load_scene(INITIAL_SCENE)


func _on_options_button_pressed() -> void:
	Settings.transition_in()

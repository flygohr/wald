extends Node2D

@onready var defeat_screen: TextureRect = $CanvasLayer/DefeatScreen
@onready var victory_screen: TextureRect = $CanvasLayer/VictoryScreen

@onready var game_end_label: Label = $CanvasLayer/PanelContainer/VBoxContainer/GameEndLabel
@onready var game_end_text: Label = $CanvasLayer/PanelContainer/VBoxContainer/GameEndText

const INITIAL_SCENE: StringName = ScenesManager.SCENE_PATHS[ScenesManager.KEY_OVERWORLD_SCREEN]
const TITLE_SCENE: StringName = ScenesManager.SCENE_PATHS[ScenesManager.KEY_TITLE_SCREEN]


var victory_title: String = "WELL DONE"
var victory_text: String = "You reached THE LAST CITY.\nYou are safe... for now."

var defeat_title: String = "IT'S OVER"
var defeat_text: String = "The FOREST got the best of you.\nRest in peace, adventurer."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameData.current[GameData.KEY_IS_GAME_ENDED] == true:
		if GameData.current[GameData.KEY_IS_GAME_WON] == true:
			defeat_screen.hide()
			victory_screen.show()
			game_end_label.text = victory_title
			game_end_text.text = victory_text
		else:
			defeat_screen.show()
			victory_screen.hide()
			game_end_label.text = defeat_title
			game_end_text.text = defeat_text


func _on_new_game_button_pressed() -> void:
	_reset_game()
	ScenesManager.load_scene(INITIAL_SCENE)


func _on_quit_button_pressed() -> void:
	_reset_game()
	ScenesManager.load_scene(TITLE_SCENE)

func _reset_game() -> void:
	var game_number = GameData.current[GameData.KEY_GAMES_PLAYED]+1
	GameData.current = GameData.DEFAULT_GAME_DATA.duplicate_deep()
	GameData.current[GameData.KEY_GAMES_PLAYED] = game_number
	GameData.initiate_save_game_data()

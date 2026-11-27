extends Node

const INTRO_1: String = "There’s no world anymore.\n\nThere’s only THE FOREST, with its eternal fog and crumbling ruins."
const INTRO_2: String = "THE FOREST has a mind of its own, and the mind wants my life.\n\nEvery day here could be my last."
const INTRO_3: String = "Rumors of one LAST CITY reached me through the undergrowth.\n\nRumors of one last, safe place for all of the living, and some of the dead."
const INTRO_4: String = "I want to go there.\n\nI have to be careful… it’s dangerous to go alone."

const TUTORIAL_SLIDE: String = "Drag to move around the map, and click a location within your walking range to select it.\n\nYou can use the buttons in the bottom-left to enter or exit a location screen, or to see your characters.\n\nGood luck out there!"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.new_game_started.connect(show_intro)
	


func show_intro() -> void:
	
	if GameData.current[GameData.KEY_GAMES_PLAYED] == 0:
		PopupManager.show_popup_dialog(INTRO_1, "Next", true)
		await PopupManager.next_button_pressed
		PopupManager.show_popup_dialog(INTRO_2, "Next", true)
		await PopupManager.next_button_pressed
		PopupManager.show_popup_dialog(INTRO_3, "Next", true)
		await PopupManager.next_button_pressed
		PopupManager.show_popup_dialog(INTRO_4, "Start adventure", true)
		
		await PopupManager.next_button_pressed
		await get_tree().create_timer(2.0).timeout
		SignalBus.pan_to.emit(GameData.current[GameData.KEY_MAP_NODES_DATA][0][GameData.KEY_MAPNODE_POS], 5.0)
		await SignalBus.pan_finished
		PopupManager.show_popup_dialog(TUTORIAL_SLIDE, "Close", false)
	else:
		await get_tree().create_timer(2.0).timeout
		SignalBus.pan_to.emit(GameData.current[GameData.KEY_MAP_NODES_DATA][0][GameData.KEY_MAPNODE_POS], 4.0)
		await SignalBus.pan_finished
	
	GameData.current[GameData.KEY_IS_NEW_GAME] = false
	GameData.initiate_save_game_data()
	

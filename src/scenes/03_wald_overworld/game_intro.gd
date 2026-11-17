extends Node

const INTRO_1: String = "There’s no world anymore.\n\nThere’s only THE FOREST, with its eternal fog and crumbling ruins."
const INTRO_2: String = "THE FOREST has a mind of its own, and the mind wants my life.\n\nEvery day here could be my last."
const INTRO_3: String = "Rumors of one LAST CITY reached me through the undergrowth.\n\nRumors of one last, safe place for all of the living, and some of the dead."
const INTRO_4: String = "I want to go there.\n\nI have to be careful… it’s dangerous to go alone."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.new_game_started.connect(show_intro)


func show_intro() -> void:
	var random_days: int = randi_range(200, 600)
	GameData.current[GameData.KEY_CURRENT_DAY] = random_days
	SignalBus.days_updated.emit()
	GameData.initiate_save_game_data()
	
	if GameData.current[GameData.KEY_GAMES_PLAYED] == 0:
		PopupManager.show_popup_dialog(INTRO_1, "Next", true)
		await PopupManager.next_button_pressed
		PopupManager.show_popup_dialog(INTRO_2, "Next", true)
		await PopupManager.next_button_pressed
		PopupManager.show_popup_dialog(INTRO_3, "Next", true)
		await PopupManager.next_button_pressed
		PopupManager.show_popup_dialog(INTRO_4, "Start adventure", true)
	
	# TODO: start tutorial here
	

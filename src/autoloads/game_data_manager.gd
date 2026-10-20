# Script to store the game data that will end into a savefile and are needed to run the game
# Kept separate from the SaveManager for compartimentalization

extends Node

const GAME_NAME: String = "Godot Jam Template"
const GAME_VERSION: String = "0.2"

# GAME CONFIG
const KEY_MUSIC_VOLUME: String = "music_volume"
const KEY_SFX_VOLUME: String = "sfx_volume"

var config: Dictionary = {
	KEY_MUSIC_VOLUME: 100,
	KEY_SFX_VOLUME: 100
}

# GAME DATA
# Variables to keep track of during gameplay
var active_save_slot: int = 1
var is_in_game: bool = false # Track if in game for settings menu options

# KEYS
# Strings to organize the data into a Dictionary and later into a JSON
const KEY_GAME_VERSION: String = "game version"
const KEY_IS_NEW_GAME: String = "is new game"
const KEY_DUMMY_DATA: String = "dummy text data"

# DEFAULT GAME DATA
# What to load into a new save
const DEFAULT_GAME_DATA: Dictionary = {
	KEY_GAME_VERSION: GAME_VERSION,
	KEY_IS_NEW_GAME: true,
	KEY_DUMMY_DATA: "Default dummy data"
}

# CURRENT GAME DATA
# Dictionary to load the current state of the game into, and to pass into SavesManager
# Also polling this every time I need to know something

var current: Dictionary = DEFAULT_GAME_DATA.duplicate_deep() # Defaults to base game data on load

func _ready() -> void:
	# Load and apply configuration
	SavesManager.load_config(config)
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"),config[KEY_MUSIC_VOLUME]/100.00)
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"),config[KEY_SFX_VOLUME]/100.00)

	SavesManager.load_save(current, active_save_slot)
	
func initiate_load_game_data() -> void:
	SavesManager.load_save(current, active_save_slot)

func initiate_save_game_data() -> void:
	SavesManager.save_game(current, active_save_slot)

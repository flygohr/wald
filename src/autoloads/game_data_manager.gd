# Script to store the game data that will end into a savefile and are needed to run the game
# Kept separate from the SaveManager for compartimentalization

extends Node

# DEFINITIONS --------------------------------------------------------------------------------------
const GAME_NAME: String = "Wald"
const GAME_VERSION: String = "0.2"


# MAP GENERATION OPTIONS ---------------------------------------------------------------------------
const SHORT_WALK_DISTANCE: int = 400
const MEDIUM_WALK_DISTANCE: int = 800
const LONG_WALK_DISTANCE: int = 1200


# CONFIG -------------------------------------------------------------------------------------------
const KEY_MUSIC_VOLUME: String = "music_volume"
const KEY_SFX_VOLUME: String = "sfx_volume"

var config: Dictionary[String, int] = {
	KEY_MUSIC_VOLUME: 100,
	KEY_SFX_VOLUME: 100
}


# GAMEPLAY VARIABLES -------------------------------------------------------------------------------
var active_save_slot: int = 1
var is_in_game: bool = false # Track if in game for settings menu options


# KEYS ---------------------------------------------------------------------------------------------
# Strings to organize the data into a Dictionary and later into a JSON
const KEY_GAME_VERSION: String = "game version"
const KEY_IS_NEW_GAME: String = "is new game"


# MAP DATA -----------------------------------------------------------------------------------------
const KEY_MAP_NODES_DATA: String = "map nodes data"
const KEY_MAP_CURRENT_NODE_INDEX: String = "current node index"

# MAP NODE DEFINITIONS -----------------------------------------------------------------------------
const KEY_MAPNODE_ID: String = "map node id"
const KEY_MAPNODE_POS: String = "position"
const KEY_MAPNODE_DEGREE : String ="degree"
const KEY_MAPNODE_DEPTH: String = "depth"
const KEY_PREVIOUSNODE_COORDS: String = "previous coords"

const KEY_MAPNODETYPE: String = "map node type"

const KEY_MAPNODETYPE_DEFAULT: String = "default"
const KEY_MAPNODETYPE_START: String = "start"
const KEY_MAPNODETYPE_FINISH: String = "finish"
const KEY_MAPNODETYPE_OBSTACLE: String = "obstacle"
const KEY_MAPNODETYPE_SOLUTION: String = "solution"
const KEY_MAPNODETYPE_EVENT: String = "event"


# MAP BOUNDARIES DEFINITIONS -----------------------------------------------------------------------
const KEY_MAP_BOUNDARIES: String = "map boundaries"
const KEY_LEFT_X: String = "left x"
const KEY_TOP_Y: String = "top y"
const KEY_RIGHT_X: String = "right x"
const KEY_BOTTOM_Y: String = "bottom y"

const KEY_MAP_MIDPOINT: String = "midpoint coords"
const KEY_MAP_MAP_RADIUS: String = "map radius"


# DEFAULT GAME DATA --------------------------------------------------------------------------------
# What to load into a new save
const DEFAULT_GAME_DATA: Dictionary = {
	KEY_GAME_VERSION: GAME_VERSION,
	KEY_IS_NEW_GAME: true,
	KEY_MAP_NODES_DATA: [
		{
			KEY_MAPNODE_ID: 0,
			KEY_MAPNODE_POS: Vector2.ZERO,
			KEY_MAPNODE_DEGREE: 1,
			KEY_MAPNODE_DEPTH: 1,
			KEY_PREVIOUSNODE_COORDS: Vector2.ZERO,
			KEY_MAPNODETYPE: KEY_MAPNODETYPE_DEFAULT
		}
	],
	KEY_MAP_CURRENT_NODE_INDEX: 0,
	KEY_MAP_BOUNDARIES: {
		KEY_LEFT_X: Vector2.ZERO,
		KEY_TOP_Y: Vector2.ZERO,
		KEY_RIGHT_X: Vector2.ZERO,
		KEY_BOTTOM_Y: Vector2.ZERO
	},
	KEY_MAP_MIDPOINT: Vector2.ZERO,
	KEY_MAP_MAP_RADIUS: 0,
}


# CURRENT GAME DATA --------------------------------------------------------------------------------
# Dictionary to load the current state of the game into, and to pass into SavesManager
# Also polling this every time I need to know something
var current: Dictionary = DEFAULT_GAME_DATA.duplicate_deep() # Defaults to base game data on load


# STARTUP ------------------------------------------------------------------------------------------
func _ready() -> void:
	# Load and apply configuration
	SavesManager.load_config(config)
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"),config[KEY_MUSIC_VOLUME]/100.00)
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"),config[KEY_SFX_VOLUME]/100.00)

	initiate_load_game_data()


# UTILITIES ----------------------------------------------------------------------------------------
func initiate_load_game_data() -> void:
	SavesManager.load_save(current, active_save_slot)


func initiate_save_game_data() -> void:
	SavesManager.save_game(current, active_save_slot)

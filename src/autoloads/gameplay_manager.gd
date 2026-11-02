extends Node

# Script to manage the game data before passing it to the GameData -------------

func update_walking_distance(value: int) -> void:
	GameData.current[GameData.KEY_CURRENT_WALKING_DISTANCE] = value
	SignalBus.walk_distance_updated.emit(GameData.current[GameData.KEY_CURRENT_WALKING_DISTANCE])
	GameData.initiate_save_game_data()


func update_node_status(i: int, toggle: bool) -> void:
	GameData.current[GameData.KEY_MAP_NODES_DATA][i][GameData.KEY_IS_CLEARED] = toggle
	SignalBus.node_status_updated.emit(GameData.current[GameData.KEY_MAP_NODES_DATA][i][GameData.KEY_IS_CLEARED])
	GameData.initiate_save_game_data()

	
func update_sanity(value: int) -> void:
	GameData.current[GameData.KEY_CURRENT_SANITY] += value
	SignalBus.sanity_updated.emit(GameData.current[GameData.KEY_CURRENT_SANITY])
	GameData.initiate_save_game_data()


func update_food(value: int) -> void:
	GameData.current[GameData.KEY_CURRENT_FOOD] += value
	SignalBus.food_updated.emit(GameData.current[GameData.KEY_CURRENT_FOOD])
	GameData.initiate_save_game_data()


func update_karma(value: int) -> void:
	GameData.current[GameData.KEY_CURRENT_KARMA] += value
	SignalBus.karma_updated.emit(GameData.current[GameData.KEY_CURRENT_KARMA])
	GameData.initiate_save_game_data()


func update_loot(value: int) -> void:
	GameData.current[GameData.KEY_CURRENT_LOOT] += value
	SignalBus.loot_updated.emit(GameData.current[GameData.KEY_CURRENT_LOOT])
	GameData.initiate_save_game_data()

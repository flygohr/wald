extends Control

@onready var decrease_distance_button: Button = $HBoxContainer/VBoxContainer/DecreaseDistanceButton
@onready var decrease_sanity_button: Button = $HBoxContainer/VBoxContainer/DecreaseSanityButton
@onready var decrease_food_button: Button = $HBoxContainer/VBoxContainer/DecreaseFoodButton
@onready var decrease_karma_button: Button = $HBoxContainer/VBoxContainer/DecreaseKarmaButton
@onready var decrease_loot_button: Button = $HBoxContainer/VBoxContainer/DecreaseLootButton
@onready var block_button: Button = $HBoxContainer/VBoxContainer2/BlockButton
@onready var increase_distance_button: Button = $HBoxContainer/VBoxContainer2/IncreaseDistanceButton
@onready var increase_sanity_button: Button = $HBoxContainer/VBoxContainer2/IncreaseSanityButton
@onready var increase_food_button: Button = $HBoxContainer/VBoxContainer2/IncreaseFoodButton
@onready var increase_karma_button: Button = $HBoxContainer/VBoxContainer2/IncreaseKarmaButton
@onready var increase_loot_button: Button = $HBoxContainer/VBoxContainer2/IncreaseLootButton

@onready var feature_description_label: Label = $HBoxContainer/VBoxContainer/FeatureDescriptionLabel
@onready var feature_label: Label = $HBoxContainer/VBoxContainer2/FeatureLabel

@onready var new_action_prompt_button: Button = $HBoxContainer/VBoxContainer/NewActionPromptButton

func _ready() -> void:
	
	feature_label.text = str(GameData.current[GameData.KEY_MAP_NODES_DATA][GameData.current[GameData.KEY_MAP_CURRENT_NODE_INDEX]][GameData.KEY_MAPNODEFEATURE])
	
	if GameData.is_debug == true:
		if GameData.is_inside_node == true:
			show()
			feature_description_label.mouse_filter = Control.MOUSE_FILTER_STOP
			feature_label.mouse_filter = Control.MOUSE_FILTER_STOP
			decrease_distance_button.mouse_filter = Control.MOUSE_FILTER_STOP
			decrease_sanity_button.mouse_filter = Control.MOUSE_FILTER_STOP
			decrease_food_button.mouse_filter = Control.MOUSE_FILTER_STOP
			decrease_karma_button.mouse_filter = Control.MOUSE_FILTER_STOP
			decrease_loot_button.mouse_filter = Control.MOUSE_FILTER_STOP
			block_button.mouse_filter = Control.MOUSE_FILTER_STOP
			increase_distance_button.mouse_filter = Control.MOUSE_FILTER_STOP
			increase_sanity_button.mouse_filter = Control.MOUSE_FILTER_STOP
			increase_food_button.mouse_filter = Control.MOUSE_FILTER_STOP
			increase_karma_button.mouse_filter = Control.MOUSE_FILTER_STOP
			increase_loot_button.mouse_filter = Control.MOUSE_FILTER_STOP
			new_action_prompt_button.mouse_filter = Control.MOUSE_FILTER_STOP
		elif GameData.is_inside_node == false:
			hide()
			feature_description_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
			feature_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
			decrease_distance_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
			decrease_sanity_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
			decrease_food_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
			decrease_karma_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
			decrease_loot_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
			block_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
			increase_distance_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
			increase_sanity_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
			increase_food_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
			increase_karma_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
			increase_loot_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
			new_action_prompt_button.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_clear_button_pressed() -> void:
	print_debug("Node has been cleared")
	Gameplay.update_node_status(GameData.current[GameData.KEY_MAP_CURRENT_NODE_INDEX], true)


func _on_reset_button_pressed() -> void:
	print_debug("Node has been blocked")
	Gameplay.update_node_status(GameData.current[GameData.KEY_MAP_CURRENT_NODE_INDEX], false)


func _on_decrease_distance_button_pressed() -> void:
	var distance_values: Array = [
		GameData.SHORT_WALK_DISTANCE, GameData.MEDIUM_WALK_DISTANCE, GameData.LONG_WALK_DISTANCE
	]
	
	var current_distance: int = GameData.current[GameData.KEY_CURRENT_WALKING_DISTANCE]
	
	var current_distance_index: int = distance_values.find(current_distance)
	
	match current_distance_index:
		0:
			pass
		1:
			Gameplay.update_walking_distance(GameData.SHORT_WALK_DISTANCE)
		2:
			Gameplay.update_walking_distance(GameData.MEDIUM_WALK_DISTANCE)
			
	print_debug("Decreasing walking distance")


func _on_increase_distance_button_pressed() -> void:
	var distance_values: Array = [
		GameData.SHORT_WALK_DISTANCE, GameData.MEDIUM_WALK_DISTANCE, GameData.LONG_WALK_DISTANCE
	]
	
	var current_distance: int = GameData.current[GameData.KEY_CURRENT_WALKING_DISTANCE]
	
	var current_distance_index: int = distance_values.find(current_distance)
	
	match current_distance_index:
		0:
			Gameplay.update_walking_distance(GameData.MEDIUM_WALK_DISTANCE)
		1:
			Gameplay.update_walking_distance(GameData.LONG_WALK_DISTANCE)
		2:
			pass
			
	print_debug("Increasing walking distance")


func _on_decrease_sanity_button_pressed() -> void:
	Gameplay.update_sanity(-10)


func _on_increase_sanity_button_pressed() -> void:
	Gameplay.update_sanity(+10)


func _on_decrease_food_button_pressed() -> void:
	Gameplay.update_food(-10)


func _on_increase_food_button_pressed() -> void:
	Gameplay.update_food(+10)


func _on_decrease_karma_button_pressed() -> void:
	Gameplay.update_karma(-10)


func _on_increase_karma_button_pressed() -> void:
	Gameplay.update_karma(+10)


func _on_decrease_loot_button_pressed() -> void:
	Gameplay.update_loot(-10)


func _on_increase_loot_button_pressed() -> void:
	Gameplay.update_loot(+10)


func _on_new_action_prompt_button_pressed() -> void:
	SignalBus.action_prompt_created.emit()

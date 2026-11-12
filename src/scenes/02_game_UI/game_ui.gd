extends CanvasLayer

#TODO: tweak UI depending on current scene, if wald or local
@onready var overworld_button: TextureButton = $MarginContainer/VBoxContainer/Bottom/LeftButtonsContainer/OverworldButton
@onready var go_inside_node_button: TextureButton = $MarginContainer/VBoxContainer/Bottom/LeftButtonsContainer/GoInsideNodeButton
@onready var party_button: TextureButton = $MarginContainer/VBoxContainer/Bottom/LeftButtonsContainer/PartyButton

@onready var basic_actions: PanelContainer = $MarginContainer/VBoxContainer/Bottom/ActionButtonsContainer/BasicActions

@export var action_prompt_scene: PackedScene
@onready var action_buttons_container: VBoxContainer = $MarginContainer/VBoxContainer/Bottom/ActionButtonsContainer

@onready var sanity_label: Label = $MarginContainer/VBoxContainer/Top/TopLeft/StatsContainer/HBoxContainer/HBoxContainer/MarginContainer/SanityLabel
@onready var food_label: Label = $MarginContainer/VBoxContainer/Top/TopLeft/StatsContainer/HBoxContainer/HBoxContainer2/MarginContainer/FoodLabel
@onready var karma_label: Label = $MarginContainer/VBoxContainer/Top/TopLeft/StatsContainer/HBoxContainer/HBoxContainer3/MarginContainer/KarmaLabel
@onready var loot_label: Label = $MarginContainer/VBoxContainer/LootBar/TopLeft/LootStatContainer/HBoxContainer/MarginContainer/LootLabel


func _ready() -> void:
	
	if GameData.is_inside_node == true:
		overworld_button.show()
		basic_actions.show()
		go_inside_node_button.hide()
	elif GameData.is_inside_node == false:
		overworld_button.hide()
		basic_actions.hide()
		go_inside_node_button.show()
		
	
	SignalBus.sanity_updated.connect(update_sanity)
	SignalBus.food_updated.connect(update_food)
	SignalBus.karma_updated.connect(update_karma)
	SignalBus.loot_updated.connect(update_loot)
	SignalBus.action_prompt_created.connect(display_action_prompt)
	
	sanity_label.text = str(GameData.current[GameData.KEY_CURRENT_SANITY])
	food_label.text = str(GameData.current[GameData.KEY_CURRENT_FOOD])
	karma_label.text = str(GameData.current[GameData.KEY_CURRENT_KARMA])
	loot_label.text = str(GameData.current[GameData.KEY_CURRENT_LOOT])


func display_action_prompt(prompt_data: Dictionary = ActionsData.DEBUG_ACTION.duplicate_deep(), unique: bool = true) -> void:
	
	#const DEBUG_ACTION: Dictionary = {
		#KEY_NAME: "Debug action",
		#KEY_ICON: 0,
		#KEY_COSTS: [
			#{KEY_COST_SANITY: 10},
			#{KEY_COST_KARMA: 10}
		#],
		#KEY_BUTTON_TEXT: "Debug action",
		#KEY_RESULT: [
			#{KEY_RESULT_FOOD: 20}
		#]
	#}
	
	if unique:
		var children = action_buttons_container.get_children()
		for child in children:
			child.queue_free()
	
	var action_prompt: ActionPrompt = action_prompt_scene.instantiate()
	action_buttons_container.add_child(action_prompt)
	action_buttons_container.move_child(action_prompt, 0)
	action_prompt.populate(
		prompt_data[ActionsData.KEY_NAME],
		prompt_data[ActionsData.KEY_ICON],
		prompt_data[ActionsData.KEY_COSTS],
		prompt_data[ActionsData.KEY_BUTTON_TEXT],
		prompt_data[ActionsData.KEY_RESULT]
	)


func _on_quit_button_pressed() -> void:
	ScenesManager.load_scene(ScenesManager.SCENE_PATHS[ScenesManager.KEY_TITLE_SCREEN])


func _on_menu_button_pressed() -> void:
	Settings.transition_in()


func _on_overworld_button_pressed() -> void:
	GameData.is_inside_node = false
	GameData.initiate_save_game_data()
	ScenesManager.load_scene(ScenesManager.SCENE_PATHS[ScenesManager.KEY_OVERWORLD_SCREEN])


func _on_go_inside_node_button_pressed() -> void:
	GameData.is_inside_node = true
	GameData.initiate_save_game_data()
	ScenesManager.load_scene(ScenesManager.SCENE_PATHS[ScenesManager.KEY_INSIDE_NODE_SCREEN])


func update_sanity(value: int) -> void:
	sanity_label.text = str(value)


func update_food(value: int) -> void:
	food_label.text = str(value)


func update_karma(value: int) -> void:
	karma_label.text = str(value)


func update_loot(value: int) -> void:
	loot_label.text = str(value)

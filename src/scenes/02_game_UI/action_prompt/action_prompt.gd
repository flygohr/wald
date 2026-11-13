extends PanelContainer
class_name ActionPrompt

@export var cost_box_scene: PackedScene

@onready var prompt_icon: TextureRect = $VBoxContainer/HBoxContainer/PromptIcon

@onready var prompt_name: Label = $VBoxContainer/HBoxContainer/PromptName
@onready var cost_container: HBoxContainer = $VBoxContainer/MarginContainer/CostContainer
@onready var prompt_button: Button = $VBoxContainer/PromptButton

var target_node_index: int
var cost_references: Array = []

var results_to_execute: Array = []
var costs_to_evaluate: Array = []
#TODO: convert in all purposes prompt with costs, title, icon, etc

#TODO: connect signal to build and display new prompt in the UI! but this needs to go in the UI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = 0
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	SignalBus.moved_around_the_map.connect(_fade_out_this)


func populate(
	prompt_name_str: String, 
	prompt_icon_res: Texture2D, 
	prompt_costs_array: Array, 
	prompt_btn_text: String, 
	prompt_result_array: Array
	) -> void:
		prompt_name.text = prompt_name_str
		
		prompt_icon.texture = prompt_icon_res
		
		costs_to_evaluate = prompt_costs_array
		for cost in prompt_costs_array:
			var cost_box: CostBox = cost_box_scene.instantiate()
			
			cost_container.add_child(cost_box)
			cost_box.populate(cost)
		
		prompt_button.text = prompt_btn_text
		
		results_to_execute = prompt_result_array
		
		_fade_in_this()
	

func _fade_in_this() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.3).set_trans(Tween.TRANS_SINE)


func _fade_out_this() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.3).set_trans(Tween.TRANS_SINE)
	queue_free()


func _on_prompt_button_pressed() -> void:
	for result in results_to_execute:
		match result[ActionsData.KEY_RESULT_TYPE]:
			ActionsData.KEY_RESULT_TRAVEL:
				_evaluate_travel(result[ActionsData.KEY_RESULT_VALUE])
		

func _evaluate_travel(index: int) -> void:
# check costs, if too much, gamble question?
	var costs_evaluation: Array = evaluate_costs(costs_to_evaluate)
	
	if costs_evaluation[0] == false: # If sanity is low, gamble
		SignalBus.pause_map.emit(true)
		PopupManager.show_popup_confirmation("The FOREST has taken a toll on your mind. You don't have enough of it left to attempt this journey. But you can try anyways.\n\nWill you?")
		var popup_result = await PopupManager.popup_results
		var roll_result: float = randf()
		if popup_result and roll_result > 0.5:
			_execute_travel(index)
			_fade_out_this()
		elif popup_result and roll_result <= 0.5:
			GameData.current[GameData.KEY_IS_GAME_ENDED] = true
			GameData.initiate_save_game_data()
			ScenesManager.load_scene(ScenesManager.SCENE_PATHS[ScenesManager.KEY_GAME_END_SCREEN])
		SignalBus.pause_map.emit(false)
		return
	
	if costs_evaluation[1] == false: # If food is low, gamble
		SignalBus.pause_map.emit(true)
		PopupManager.show_popup_confirmation("Your belly is grumbling, and the journey ahead is long. You might not make it to your destination, but you can try anyways.\n\nWill you?")
		var popup_result = await PopupManager.popup_results
		var roll_result: float = randf()
		if popup_result and roll_result > 0.5:
			_execute_travel(index)
			_fade_out_this()
		elif popup_result and roll_result <= 0.5:
			GameData.current[GameData.KEY_IS_GAME_ENDED] = true
			GameData.initiate_save_game_data()
			ScenesManager.load_scene(ScenesManager.SCENE_PATHS[ScenesManager.KEY_GAME_END_SCREEN])
		SignalBus.pause_map.emit(false)
		return
		
	_execute_travel(index)


func _execute_travel(index: int) -> void:
	process_costs(costs_to_evaluate)
	SignalBus.traveled_to.emit(GameData.current[GameData.KEY_MAP_CURRENT_NODE_INDEX], index)

func evaluate_costs(costs: Array) -> Array:
	var sanity_check: bool = true
	var food_check: bool = true
	var karma_check: bool = true
	for cost in costs_to_evaluate:
		match cost[ActionsData.KEY_COST_ICON]:
			ActionsData.PROMPT_ICONS[ActionsData.ICON_SANITY]:
				sanity_check = _evaluate_sanity(cost[ActionsData.KEY_COST_VALUE])
			
			ActionsData.PROMPT_ICONS[ActionsData.ICON_FOOD]:
				food_check = _evaluate_food(cost[ActionsData.KEY_COST_VALUE])
			
			ActionsData.PROMPT_ICONS[ActionsData.ICON_KARMA]:
				karma_check = _evaluate_karma(cost[ActionsData.KEY_COST_VALUE])
				
	return [sanity_check, food_check, karma_check]
	
func process_costs(costs: Array) -> void:
	for cost in costs_to_evaluate:
		match cost[ActionsData.KEY_COST_ICON]:
			ActionsData.PROMPT_ICONS[ActionsData.ICON_SANITY]:
				Gameplay.update_sanity(-cost[ActionsData.KEY_COST_VALUE])
			
			ActionsData.PROMPT_ICONS[ActionsData.ICON_FOOD]:
				Gameplay.update_food(-cost[ActionsData.KEY_COST_VALUE])
			
			ActionsData.PROMPT_ICONS[ActionsData.ICON_KARMA]:
				Gameplay.update_karma(-cost[ActionsData.KEY_COST_VALUE])
				

func _evaluate_sanity(value: int) -> bool:
	if GameData.current[GameData.KEY_CURRENT_SANITY] < value:
		return false
	else:
		return true
	
func _evaluate_food(value: int) -> bool:
	if GameData.current[GameData.KEY_CURRENT_FOOD] < value:
		return false
	else:
		return true
		
func _evaluate_karma(value: int) -> bool:
	if GameData.current[GameData.KEY_CURRENT_KARMA] < value:
		return false
	else:
		return true

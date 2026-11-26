extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# places need to lump together costs and results, and this will handle them all from different places
# displaying stuff will be handled by other bits of the code
# move here all the result and cost processing
# when done, await for prompt signal confirmation to display one last prompt with
# "You gained / you lost and some costboxes in it"

func process_prompt(costs: Array, results: Array, prompt_name: String = ""):
	process_results(costs, results, prompt_name)


func process_costs(costs: Array) -> void:
	for cost in costs:
		match cost[ActionsData.KEY_COST_ICON]:
			ActionsData.PROMPT_ICONS[ActionsData.ICON_SANITY]:
				Gameplay.update_sanity(-cost[ActionsData.KEY_COST_VALUE])
			
			ActionsData.PROMPT_ICONS[ActionsData.ICON_FOOD]:
				Gameplay.update_food(-cost[ActionsData.KEY_COST_VALUE])
			
			ActionsData.PROMPT_ICONS[ActionsData.ICON_KARMA]:
				Gameplay.update_karma(-cost[ActionsData.KEY_COST_VALUE])


func process_results(costs: Array, results: Array, prompt_name: String) -> void:
	for result in results:
		match result[ActionsData.KEY_RESULT_TYPE]:
			ActionsData.KEY_RESULT_TRAVEL:
				_evaluate_travel(costs, result[ActionsData.KEY_RESULT_VALUE])
			ActionsData.KEY_RESULT_PROMPT:
				_execute_prompt(result[ActionsData.KEY_RESULT_VALUE])
			ActionsData.KEY_RESULT_DAYS:
				_process_stat(ActionsData.KEY_RESULT_DAYS, result[ActionsData.KEY_RESULT_VALUE])
			ActionsData.KEY_RESULT_LOOT:
				_process_stat(ActionsData.KEY_RESULT_LOOT, result[ActionsData.KEY_RESULT_VALUE])
			ActionsData.KEY_RESULT_SANITY:
				_process_stat(ActionsData.KEY_RESULT_SANITY, result[ActionsData.KEY_RESULT_VALUE])
			ActionsData.KEY_RESULT_FOOD:
				_process_stat(ActionsData.KEY_RESULT_FOOD, result[ActionsData.KEY_RESULT_VALUE])
			ActionsData.KEY_RESULT_KARMA:
				_process_stat(ActionsData.KEY_RESULT_KARMA, result[ActionsData.KEY_RESULT_VALUE])
			ActionsData.KEY_RESULT_CHARACTER:
				_process_character(result[ActionsData.KEY_RESULT_VALUE])
				
	SignalBus.fade_out_prompt.emit(prompt_name)

func _process_character(character: String) -> void:
	print("Processing character ", character)
	match character:
		ActionsData.KEY_RABBIT:
			print("Rabbit joined the party")
			GameData.current[GameData.KEY_RABBIT_IN_PARTY] = true
			GameData.current[GameData.KEY_CURRENT_WALKING_DISTANCE] = GameData.LONG_WALK_DISTANCE

func _process_stat(resource: String, amount: int) -> void:
	match resource:
		ActionsData.KEY_RESULT_DAYS:
			GameData.current[GameData.KEY_CURRENT_DAY] += amount
			SignalBus.days_updated.emit(GameData.current[GameData.KEY_CURRENT_DAY])
		ActionsData.KEY_RESULT_LOOT:
			GameData.current[GameData.KEY_CURRENT_LOOT] += amount
			SignalBus.loot_updated.emit(GameData.current[GameData.KEY_CURRENT_LOOT])
		ActionsData.KEY_RESULT_SANITY:
			GameData.current[GameData.KEY_CURRENT_SANITY] += amount
			SignalBus.sanity_updated.emit(GameData.current[GameData.KEY_CURRENT_SANITY])
		ActionsData.KEY_RESULT_FOOD:
			GameData.current[GameData.KEY_CURRENT_FOOD] += amount
			SignalBus.food_updated.emit(GameData.current[GameData.KEY_CURRENT_FOOD])
		ActionsData.KEY_RESULT_KARMA:
			print("Karma: ", amount)
			GameData.current[GameData.KEY_CURRENT_KARMA] += amount
			SignalBus.karma_updated.emit(GameData.current[GameData.KEY_CURRENT_KARMA])
	
	GameData.initiate_save_game_data()


func _execute_prompt(data: Dictionary) -> void:
	#const PROMPT_TEMPLATE: Dictionary = {
		#KEY_IS_NEUTRAL: false,
		#KEY_TIMES_USED: 0,
		#KEY_USAGE_LIMIT: 1,
		#KEY_TEXT_SLIDES: [
			#"Slide 1",
			#"Slide 2",
			#"Slide 3"
		#],
		#KEY_TEXT_NEGATIVE: "Negative result",
		#KEY_TEXT_POSITIVE: "Positive result",
		#KEY_TEXT_NEUTRAL: "Neutral result",
		#KEY_NEGATIVE_RESULTS: [],
		#KEY_POSITIVE_RESULTS: [],
		#KEY_NEUTRAL_RESULTS: []
	#}
	
	# if neutral, proceed normally
	if data[ActionsData.KEY_IS_NEUTRAL] == true:
		for slide in data[ActionsData.KEY_TEXT_SLIDES]:
			PopupManager.show_popup_dialog(slide, data[ActionsData.KEY_TEXT_NEUTRAL], true)
			await PopupManager.next_button_pressed
		process_prompt([], data[ActionsData.KEY_NEUTRAL_RESULTS])
	else:
		var mix_up_answers: float = randf()
		var result: bool
		
		for i in range(data[ActionsData.KEY_TEXT_SLIDES].size()):
			if i < data[ActionsData.KEY_TEXT_SLIDES].size()-1:
				PopupManager.show_popup_dialog(data[ActionsData.KEY_TEXT_SLIDES][i], "Next", true)
				await PopupManager.next_button_pressed
			else:
				if mix_up_answers < 0.5:
					PopupManager.show_popup_confirmation(data[ActionsData.KEY_TEXT_SLIDES][i], data[ActionsData.KEY_TEXT_NEGATIVE], data[ActionsData.KEY_TEXT_POSITIVE], true)
				else:
					PopupManager.show_popup_confirmation(data[ActionsData.KEY_TEXT_SLIDES][i], data[ActionsData.KEY_TEXT_POSITIVE], data[ActionsData.KEY_TEXT_NEGATIVE], true)

		# TODO: fix mix up

		result = await PopupManager.popup_results
		if mix_up_answers >= 0.5 and result == true: result = false # flip on answer mix
		
		if result == true:
			process_prompt([], data[ActionsData.KEY_POSITIVE_RESULTS])
		else:
			process_prompt([], data[ActionsData.KEY_NEGATIVE_RESULTS])
			
			
	
	
		
	# if not neutral, show options, wait, process one of the outcomes
	
	GameData.initiate_save_game_data()
		

func _evaluate_travel(costs: Array, index: int) -> void:
# check costs, if too much, gamble question?
	var costs_evaluation: Array = evaluate_costs(costs)
	
	if costs_evaluation[0] == false: # If sanity is low, gamble
		SignalBus.pause_map.emit(true)
		PopupManager.show_popup_confirmation("The FOREST has taken a toll on your mind. You don't have enough of it left to attempt this journey. But you can try anyways.\n\nWill you?")
		var popup_result = await PopupManager.popup_results
		var roll_result: float = randf()
		if popup_result and roll_result > 0.5:
			process_costs(costs)
			_execute_travel(costs, index)
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
			_execute_travel(costs, index)
		elif popup_result and roll_result <= 0.5:
			GameData.current[GameData.KEY_IS_GAME_ENDED] = true
			GameData.initiate_save_game_data()
			ScenesManager.load_scene(ScenesManager.SCENE_PATHS[ScenesManager.KEY_GAME_END_SCREEN])
		SignalBus.pause_map.emit(false)
		return
		
	_execute_travel(costs, index)
	
func _execute_travel(costs: Array, index: int) -> void:
	process_costs(costs)
	SignalBus.traveled_to.emit(GameData.current[GameData.KEY_MAP_CURRENT_NODE_INDEX], index)

func evaluate_costs(costs: Array) -> Array:
	var sanity_check: bool = true
	var food_check: bool = true
	var karma_check: bool = true
	for cost in costs:
		match cost[ActionsData.KEY_COST_ICON]:
			ActionsData.PROMPT_ICONS[ActionsData.ICON_SANITY]:
				sanity_check = _evaluate_sanity(cost[ActionsData.KEY_COST_VALUE])
			
			ActionsData.PROMPT_ICONS[ActionsData.ICON_FOOD]:
				food_check = _evaluate_food(cost[ActionsData.KEY_COST_VALUE])
			
			ActionsData.PROMPT_ICONS[ActionsData.ICON_KARMA]:
				karma_check = _evaluate_karma(cost[ActionsData.KEY_COST_VALUE])
				
	return [sanity_check, food_check, karma_check]

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

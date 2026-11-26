extends Node2D

var node_data: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get active node data
	node_data = GameData.current[GameData.KEY_MAP_NODES_DATA][GameData.current[GameData.KEY_MAP_CURRENT_NODE_INDEX]]
	parse_prompts()
	
func parse_prompts() -> void:
	
	if node_data[GameData.KEY_MAPNODETYPE] == GameData.KEY_MAPNODETYPE_START: return
	
	if node_data[GameData.KEY_MAPNODE_PROMPT] != null and node_data[GameData.KEY_MAPNODE_PROMPT_CLEARED] == false:
		WaldProcessor._execute_prompt(node_data[GameData.KEY_MAPNODE_PROMPT])
		node_data[GameData.KEY_MAPNODE_PROMPT_CLEARED] = true
	
	if node_data[GameData.KEY_MAPNODETYPE_PROMPT] != null and node_data[GameData.KEY_MAPNODETYPE_PROMPT_CLEARED] == false:
		SignalBus.action_prompt_created.emit(false, node_data[GameData.KEY_MAPNODETYPE_PROMPT])
		
	if node_data[GameData.KEY_MAPNODEFEATURE_PROMPT] != null and node_data[GameData.KEY_MAPNODEFEATURE_PROMPT_CLEARED] == false:
		SignalBus.action_prompt_created.emit(false, node_data[GameData.KEY_MAPNODEFEATURE_PROMPT])

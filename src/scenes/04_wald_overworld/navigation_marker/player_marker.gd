extends Node2D

var current_walking_distance: int = GameData.current[GameData.KEY_CURRENT_WALKING_DISTANCE] + 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.traveled_to.connect(move_marker)
	SignalBus.walking_distance_updated.connect(_set_walking_distance)
	global_position = GameData.current[GameData.KEY_MAP_NODES_DATA][GameData.current[GameData.KEY_MAP_CURRENT_NODE_INDEX]][GameData.KEY_MAPNODE_POS]


func _draw() -> void:
	draw_arc(Vector2.ZERO, current_walking_distance, 0, 360, 100, Color.WHITE, 3, false)
	

func move_marker(_from: int, to: int) -> void:
	var target_position: Vector2 = GameData.current[GameData.KEY_MAP_NODES_DATA][to][GameData.KEY_MAPNODE_POS]
	SignalBus.pan_to.emit(target_position)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", target_position, 0.3).set_trans(Tween.TRANS_SINE)
	GameData.current[GameData.KEY_MAP_CURRENT_NODE_INDEX] = to
	
	var needs_to_trigger_transition: bool = false
	if GameData.current[GameData.KEY_MAP_NODES_DATA][to][GameData.KEY_IS_VISITED] == false:
		needs_to_trigger_transition = true
	
	GameData.current[GameData.KEY_MAP_NODES_DATA][to][GameData.KEY_IS_VISITED] = true
	
	SignalBus.new_active_node_set.emit(to)
	GameData.initiate_save_game_data()
	queue_redraw()
	print(GameData.current[GameData.KEY_MAP_NODES_DATA][to])
	# transition to local ONLY if new node
	
	if needs_to_trigger_transition == true:
		GameData.is_inside_node = true
		await tween.finished
		ScenesManager.load_scene(ScenesManager.SCENE_PATHS[ScenesManager.KEY_INSIDE_NODE_SCREEN])

func _set_walking_distance() -> void:
	current_walking_distance = GameData.current[GameData.KEY_CURRENT_WALKING_DISTANCE] + 50
	queue_redraw()

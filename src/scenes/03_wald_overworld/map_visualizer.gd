extends Node2D

@export var base_node: PackedScene
@export var dashed_line_scene: PackedScene

func _ready() -> void:
	render_map(GameData.current[GameData.KEY_MAP_NODES_DATA])
	SignalBus.traveled_to.connect(_draw_traveled_line)


func render_map(list: Array) -> void:
	
	for i in range(list.size()):
		var node_scene: MapNode = base_node.instantiate()
		add_child(node_scene)
		if not node_scene.is_node_ready():
			await node_scene.ready
		node_scene.global_position = list[i][GameData.KEY_MAPNODE_POS]
		node_scene.index = i
		if node_scene.index == GameData.current[GameData.KEY_MAP_CURRENT_NODE_INDEX]:
			node_scene.is_active = true
		
		if list[i][GameData.KEY_IS_VISITED] == true:
			node_scene.is_visited = true
			
		if list[i][GameData.KEY_IS_CLEARED] == true:
			node_scene.is_cleared = true
		
		for line in GameData.current[GameData.KEY_TRAVELED_LINES_DATA]:
			_draw_connecting_line(line[GameData.KEY_LINE_START], line[GameData.KEY_LINE_END], 5)
		# _draw_connecting_line(node[GameData.KEY_PREVIOUSNODE_COORDS], node[GameData.KEY_MAPNODE_POS], node[GameData.KEY_MAPNODE_DEGREE])


func _draw_connecting_line(start: Vector2, end: Vector2, width: int) -> void:
	var connecting_line = Line2D.new()
	connecting_line.add_point(start)
	connecting_line.add_point(end)
	connecting_line.width = width
	connecting_line.z_index = 1
	add_child(connecting_line)

func _draw_traveled_line(_from: int, to: int) -> void:
	var start: Vector2 = GameData.current[GameData.KEY_MAP_NODES_DATA][GameData.current[GameData.KEY_MAP_CURRENT_NODE_INDEX]][GameData.KEY_MAPNODE_POS]
	var end: Vector2 = GameData.current[GameData.KEY_MAP_NODES_DATA][to][GameData.KEY_MAPNODE_POS]
	_draw_connecting_line(start, end, 5)
	GameData.current[GameData.KEY_TRAVELED_LINES_DATA].append({
		GameData.KEY_LINE_START: start,
		GameData.KEY_LINE_END: end,
		GameData.KEY_LINE_DEPTH: GameData.current[GameData.KEY_TRAVELED_LINES_DATA].size()+1
	})

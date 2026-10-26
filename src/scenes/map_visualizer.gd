extends Node

@export var base_node: PackedScene
@onready var background_pattern: Sprite2D = $BackgroundPattern


func _ready() -> void:
	render_map(GameData.current[GameData.KEY_MAP_NODES_DATA])
	render_background(
		GameData.current[GameData.KEY_MAP_BOUNDARIES][GameData.KEY_LEFT_X],
		GameData.current[GameData.KEY_MAP_BOUNDARIES][GameData.KEY_TOP_Y],
		GameData.current[GameData.KEY_MAP_BOUNDARIES][GameData.KEY_RIGHT_X],
		GameData.current[GameData.KEY_MAP_BOUNDARIES][GameData.KEY_BOTTOM_Y]
	)


func render_map(list: Array) -> void:
	
	for i in range(list.size()):
		var node_scene = base_node.instantiate()
		add_child(node_scene)
		node_scene.global_position = list[i][GameData.KEY_MAPNODE_POS]
		node_scene.update_color(list[i][GameData.KEY_MAPNODETYPE])
		node_scene.index = i
		if node_scene.index == GameData.current[GameData.KEY_MAP_CURRENT_NODE_INDEX]:
			node_scene.is_active = true
		
		# _draw_connecting_line(node[GameData.KEY_PREVIOUSNODE_COORDS], node[GameData.KEY_MAPNODE_POS], node[GameData.KEY_MAPNODE_DEGREE])


func render_background(left_x: int, top_y: int, right_x: int, bottom_y: int) -> void:
	background_pattern.region_rect = Rect2(
		left_x, 
		top_y, 
		abs(left_x) + abs(right_x), 
		abs(top_y) + abs(bottom_y))
	background_pattern.position = Vector2(left_x, top_y)


func _draw_connecting_line(start: Vector2, end: Vector2, width: int) -> void:
	var connecting_line = Line2D.new()
	connecting_line.add_point(start)
	connecting_line.add_point(end)
	connecting_line.width = 10 / width
	connecting_line.z_index = 1
	add_child(connecting_line)

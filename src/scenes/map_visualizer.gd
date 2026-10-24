extends Node

@export var base_node: PackedScene
@onready var background_pattern: Sprite2D = $BackgroundPattern

func _ready() -> void:
	SignalBus.finished_generating_map.connect(render_map)
	SignalBus.map_boundaries_set.connect(render_background)


func render_map(list: Array) -> void:

	for node in list:
		var node_scene = base_node.instantiate()
		
		node_scene.position = node[GameData.KEY_MAPNODE_POS]
		node_scene.update_color(node[GameData.KEY_MAPNODETYPE])
		
		add_child(node_scene)
		
		
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

extends Node

@export var base_node: PackedScene
@onready var background_pattern: Sprite2D = $BackgroundPattern

func _ready() -> void:
	SignalBus.finished_generating_map.connect(render_map)
	SignalBus.generated_map_limits.connect(render_background)


func render_map(list: Array) -> void:

	for node in list:
		var node_scene = base_node.instantiate()
		
		node_scene.position = node[Definitions.KEY_MAPNODE_POS]
		node_scene.update_texture(node[Definitions.KEY_MAPNODETYPE])
		
		add_child(node_scene)
		
		
		# _draw_connecting_line(node[Definitions.KEY_PREVIOUSNODE_COORDS], node[Definitions.KEY_MAPNODE_POS], node[Definitions.KEY_MAPNODE_DEGREE])


func render_background(x: int, y: int, w: int, h: int) -> void:
	background_pattern.region_rect = Rect2(x, y, w, h)
	background_pattern.position = Vector2(x, y)

func _draw_connecting_line(start: Vector2, end: Vector2, width: int) -> void:
	var connecting_line = Line2D.new()
	connecting_line.add_point(start)
	connecting_line.add_point(end)
	connecting_line.width = 10 / width
	connecting_line.z_index = 1
	add_child(connecting_line)

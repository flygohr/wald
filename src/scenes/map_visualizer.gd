extends Node

@export var base_node: PackedScene

func _ready() -> void:
	SignalBus.finished_generating_map.connect(render_map)


func render_map(list: Array) -> void:

	for node in list:
		var node_scene = base_node.instantiate()
		
		node_scene.position = node[Definitions.KEY_MAPNODE_POS]
		node_scene.update_texture(node[Definitions.KEY_MAPNODETYPE])
		
		add_child(node_scene)
		
		_draw_connecting_line(node[Definitions.KEY_PREVIOUSNODE_COORDS], node[Definitions.KEY_MAPNODE_POS], node[Definitions.KEY_MAPNODE_DEGREE])
			

func _draw_connecting_line(start: Vector2, end: Vector2, width: int) -> void:
	var connecting_line = Line2D.new()
	connecting_line.add_point(start)
	connecting_line.add_point(end)
	connecting_line.width = 10 / width
	connecting_line.z_index = 1
	add_child(connecting_line)

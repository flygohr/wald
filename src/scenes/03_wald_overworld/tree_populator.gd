extends Node2D

@export var tree_scene: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in 4000:
		var tree: TreeSprite = tree_scene.instantiate()
		var tree_x = randi_range(GameData.current[GameData.KEY_MAP_BOUNDARIES][GameData.KEY_LEFT_X], GameData.current[GameData.KEY_MAP_BOUNDARIES][GameData.KEY_RIGHT_X])
		var tree_y = randi_range(GameData.current[GameData.KEY_MAP_BOUNDARIES][GameData.KEY_TOP_Y], GameData.current[GameData.KEY_MAP_BOUNDARIES][GameData.KEY_BOTTOM_Y])
		
		add_child(tree)
		tree.global_position = Vector2(tree_x, tree_y)
		tree.set_tree(randi_range(0, 5), randf())

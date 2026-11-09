extends Node2D

@export var trees_spacing: int = 30
@export var trees_density: float = 1.3
@export var min_tree_scale: float = 0.25
@export var max_tree_scale: float = 0.35

var rng = RandomNumberGenerator.new()

@export var tree_scene: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	rng.seed = GameData.current[GameData.KEY_GAMES_PLAYED]
	print("I'm populating trees")
	var trees_amt_x: int = abs(GameData.current[GameData.KEY_MAP_BOUNDARIES][GameData.KEY_LEFT_X] + GameData.current[GameData.KEY_MAP_BOUNDARIES][GameData.KEY_RIGHT_X]) / (trees_spacing * trees_density)
	var trees_amt_y: int = abs(GameData.current[GameData.KEY_MAP_BOUNDARIES][GameData.KEY_TOP_Y] + GameData.current[GameData.KEY_MAP_BOUNDARIES][GameData.KEY_BOTTOM_Y]) / (trees_spacing * trees_density)
	
	var trees_amt: int = trees_amt_x * trees_amt_y
	print(trees_amt)
	for i in range(2500): #FIXME: this shit is not working out a useful number
		var tree: TreeSprite = tree_scene.instantiate()
		var tree_x = snapped(rng.randi_range(GameData.current[GameData.KEY_MAP_BOUNDARIES][GameData.KEY_LEFT_X], GameData.current[GameData.KEY_MAP_BOUNDARIES][GameData.KEY_RIGHT_X]), trees_spacing)
		var tree_y = snapped(rng.randi_range(GameData.current[GameData.KEY_MAP_BOUNDARIES][GameData.KEY_TOP_Y], GameData.current[GameData.KEY_MAP_BOUNDARIES][GameData.KEY_BOTTOM_Y]+100), trees_spacing)
		
		add_child(tree)
		
		var toggle: bool = false
		if rng.randf() > 0.5:
			toggle = true
		
		tree.global_position = Vector2(tree_x, tree_y)
		tree.set_tree(rng.randi_range(0, (tree.hframes*tree.vframes)-1), rng.randf(), min_tree_scale, max_tree_scale, toggle)

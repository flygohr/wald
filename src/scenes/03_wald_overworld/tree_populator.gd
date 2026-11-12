extends Node2D

@export var trees_spacing: int = 30
@export var spacing_multiplier: float = 4.0
@export var min_tree_scale: float = 0.25
@export var max_tree_scale: float = 0.35

var rng = RandomNumberGenerator.new()

@export var tree_scene: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var top_left_corner: Vector2 = Vector2(
		GameData.current[GameData.KEY_MAP_BOUNDARIES][GameData.KEY_LEFT_X],
		GameData.current[GameData.KEY_MAP_BOUNDARIES][GameData.KEY_TOP_Y]
	)
	
	var bottom_right_corner: Vector2 = Vector2(
		GameData.current[GameData.KEY_MAP_BOUNDARIES][GameData.KEY_RIGHT_X],
		GameData.current[GameData.KEY_MAP_BOUNDARIES][GameData.KEY_BOTTOM_Y]
	)
	
	rng.seed = GameData.current[GameData.KEY_GAMES_PLAYED]
	
	var area_rect: Rect2
	area_rect.position = top_left_corner
	area_rect.end = bottom_right_corner
	
	var size_w: int = area_rect.size.x
	var size_h: int = area_rect.size.y
	
	var trees_amt_x: int = size_w / (trees_spacing * spacing_multiplier)
	var trees_amt_y: int = size_h / (trees_spacing * spacing_multiplier)
	

	var trees_amt: int = trees_amt_x * trees_amt_y
	for i in range(trees_amt): #FIXME: this shit is not working out a useful number
		var tree: TreeSprite = tree_scene.instantiate()
		var tree_x = snapped(rng.randi_range(top_left_corner.x-(816/2), bottom_right_corner.x+(816/2)), trees_spacing)
		var tree_y = snapped(rng.randi_range(top_left_corner.y-(576/2), bottom_right_corner.y+(576/2)), trees_spacing)
		
		add_child(tree)
		
		var toggle: bool = false
		if rng.randf() > 0.5:
			toggle = true
		
		tree.global_position = Vector2(tree_x, tree_y)
		tree.set_tree(rng.randi_range(0, (tree.hframes*tree.vframes)-1), rng.randf(), min_tree_scale, max_tree_scale, toggle)

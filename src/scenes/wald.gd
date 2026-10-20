extends Node2D

@onready var start: Node2D = $Start

@export var short_walk_length := 200
@export var medium_walk_length := 400
@export var long_walk_length := 600

@export var map_node_base : PackedScene

@export var map_node_color_default := Color(0.275, 0.514, 0.496, 1.0)
@export var map_node_color_finish := Color(0.31, 0.737, 0.239, 1.0)

var map_nodes_list: Array = []

@export var attempts_max := 5
@export var branching_probability := 0.6

const KEY_MAPNODE_POS := "position"
const KEY_MAPNODE_DEGREE := "degree"
const KEY_MAPNODE_DEPTH := "depth"
const KEY_MAPNODETYPE := "type"
const KEY_MAPNODETYPE_FINISH := "finish"
const KEY_MAPNODETYPE_DEFAULT := "default"
const KEY_MAPNODETYPE_START := "start"

func _ready() -> void:
	draw_connection(start.position, 15)

func draw_connection(s: Vector2, map_length: int) -> void:
	
	var starting_point = s
	
	add_to_map_nodes_list(map_nodes_list, starting_point, 1, 1, KEY_MAPNODETYPE_START)
	
	# SPAWN BEST PATH ------------------------------------------------------------------------------
	
	for x in map_length:
		
		var random_angle = randi_range(-80, 80)
		var random_distance = pick_random_distance()
		
		var edge_line = Line2D.new()
		edge_line.add_point(starting_point)
		
		var target_position = Vector2.from_angle(deg_to_rad(random_angle))*random_distance+starting_point
		var new_node = map_node_base.instantiate()
		
		if x == map_length-1:
			add_to_map_nodes_list(map_nodes_list, target_position, 1, 1, KEY_MAPNODETYPE_FINISH)
			new_node.color = map_node_color_finish
		else: 
			add_to_map_nodes_list(map_nodes_list, target_position, 1, 1)
			new_node.color = map_node_color_default
		
		new_node.position = target_position
		
		edge_line.add_point(target_position)
		
		add_child(new_node)
		add_child(edge_line)
		
		starting_point = target_position
		
		# await get_tree().create_timer(0.2).timeout
		
	# SPAWN SECOND GENERATION ----------------------------------------------------------------------
	
	for x in map_nodes_list:
		
		if x[KEY_MAPNODE_DEGREE] == 1 and x[KEY_MAPNODETYPE] == KEY_MAPNODETYPE_DEFAULT:
			
			print("trying branches")
			add_branches(map_nodes_list, x, 2)
			# await get_tree().create_timer(0.2).timeout
			
	# SPAWN THIRD GENERATION -----------------------------------------------------------------------
	
	for x in map_nodes_list:
		
		if x[KEY_MAPNODE_DEGREE] == 2 and x[KEY_MAPNODETYPE] == KEY_MAPNODETYPE_DEFAULT:
			
			print("trying branches")
			add_branches(map_nodes_list, x, 4)
			# await get_tree().create_timer(0.2).timeout
			
			
	# SPAWN FOURTH GENERATION ----------------------------------------------------------------------
	
	for x in map_nodes_list:
		
		if x[KEY_MAPNODE_DEGREE] == 3 and x[KEY_MAPNODETYPE] == KEY_MAPNODETYPE_DEFAULT:
			
			print("trying branches")
			add_branches(map_nodes_list, x, 8)
			# await get_tree().create_timer(0.2).timeout
			
	# SPAWN FIFTH GENERATION -----------------------------------------------------------------------
	
	for x in map_nodes_list:
		
		if x[KEY_MAPNODE_DEGREE] == 4 and x[KEY_MAPNODETYPE] == KEY_MAPNODETYPE_DEFAULT:
			
			print("trying branches")
			add_branches(map_nodes_list, x, 3)
			# await get_tree().create_timer(0.2).timeout
			
			
func add_branches(list, starting, branches_amt) -> void:
	
	for branch_attempt in branches_amt:
		var is_there_a_new_node := false
		var branching_threshold = randf()
		
		if branching_threshold <= branching_probability:
			is_there_a_new_node = true
		
		var random_angle = randi_range(-360, 360)
		var random_distance = pick_random_distance()
		
		if is_there_a_new_node:
			var has_been_positioned = false
			
			for y in attempts_max:
				
				if has_been_positioned == false:
				
					var target_position = Vector2.from_angle(deg_to_rad(random_angle))*random_distance+starting[KEY_MAPNODE_POS]
					
					var edge_line = Line2D.new()
					edge_line.add_point(starting[KEY_MAPNODE_POS])
				
					var new_node = map_node_base.instantiate()
					new_node.color = map_node_color_default
					new_node.position = target_position
					
					edge_line.add_point(target_position)
					edge_line.width = edge_line.width/(2*starting[KEY_MAPNODE_DEGREE])
					
					var is_distant_enough = check_distance(list, target_position, short_walk_length)
					
					if is_distant_enough == true:
						add_child(new_node)
						add_child(edge_line)
						has_been_positioned = true
						
						add_to_map_nodes_list(list, target_position, starting[KEY_MAPNODE_DEGREE]+1, starting[KEY_MAPNODE_DEPTH])

		# await get_tree().create_timer(0.2).timeout
	
	
func pick_random_distance() -> int:
	return [short_walk_length, medium_walk_length, long_walk_length].pick_random()

func add_to_map_nodes_list(list: Array, pos: Vector2, degree: int, depth: int, type:=KEY_MAPNODETYPE_DEFAULT) -> void:
	var map_node_data := {
		KEY_MAPNODE_POS: pos,
		KEY_MAPNODE_DEGREE: degree,
		KEY_MAPNODE_DEPTH: depth,
		KEY_MAPNODETYPE: type
	}
	list.append(map_node_data)

func check_distance(list: Array, current_point: Vector2, distance: int) -> bool:
	var is_distant_enough := true
	for x in list:
		if current_point.distance_to(x[KEY_MAPNODE_POS]) < distance:
			is_distant_enough = false
	
	return is_distant_enough

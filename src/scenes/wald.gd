extends Node2D

@onready var start: Node2D = $Start

@export var short_walk_length := 200
@export var medium_walk_length := 400
@export var long_walk_length := 600

@export var map_node_base : PackedScene

@export var map_node_color_default := Color(0.275, 0.514, 0.496, 1.0)
@export var map_node_color_finish := Color(0.31, 0.737, 0.239, 1.0)
@export var map_node_color_solution := Color(0.776, 0.737, 0.239, 1.0)
@export var map_node_color_obstacle := Color(0.59, 0.088, 0.0, 1.0)
@export var map_node_color_event := Color(0.476, 0.198, 0.391, 1.0)

@export var obstacle_ratio := 0.5

var map_nodes_list: Array = []

@export var attempts_max := 5
@export var branching_probability := 0.6

const KEY_MAPNODE_POS := "position"
const KEY_MAPNODE_DEGREE := "degree"
const KEY_MAPNODE_DEPTH := "depth"
const KEY_MAPNODE_REFERENCE := "node reference"
const KEY_MAPNODETYPE := "type"
const KEY_MAPNODETYPE_FINISH := "finish"
const KEY_MAPNODETYPE_DEFAULT := "default"
const KEY_MAPNODETYPE_START := "start"
const KEY_MAPNODETYPE_OBSTACLE := "obstacle"
const KEY_MAPNODETYPE_SOLUTION := "solution"
const KEY_MAPNODETYPE_EVENT := "event"

var start_coords: Vector2
var finish_coords: Vector2
var middle_point: Vector2
var distance_from_middle_point: float

func _ready() -> void:
	draw_connection(start.position, 15)

func draw_connection(s: Vector2, map_length: int) -> void:
	
	var starting_point = s
	start_coords = starting_point
	
	add_to_map_nodes_list(map_nodes_list, starting_point, 1, 1, start, KEY_MAPNODETYPE_START)
	
	# SPAWN BEST PATH ------------------------------------------------------------------------------
	
	for x in map_length:
		
		var random_angle = randi_range(-80, 80)
		var random_distance = pick_random_distance()
		
		var edge_line = Line2D.new()
		edge_line.add_point(starting_point)
		
		var target_position = Vector2.from_angle(deg_to_rad(random_angle))*random_distance+starting_point
		var new_node = map_node_base.instantiate()
		
		if x == map_length-1:
			add_to_map_nodes_list(map_nodes_list, target_position, 1, x, new_node, KEY_MAPNODETYPE_FINISH)
			new_node.color = map_node_color_finish
			finish_coords = target_position
		else: 
			add_to_map_nodes_list(map_nodes_list, target_position, 1, x, new_node)
			new_node.color = map_node_color_default
		
		new_node.position = target_position
		
		edge_line.add_point(target_position)
		
		add_child(new_node)
		# add_child(edge_line)
		
		starting_point = target_position
	
	middle_point = ((finish_coords - start_coords) / 2 + start_coords)
	distance_from_middle_point = middle_point.distance_to(start_coords)
	
	# SPAWN SECOND GENERATION ----------------------------------------------------------------------
	
	for x in map_nodes_list:
		
		if x[KEY_MAPNODE_DEGREE] == 1 and x[KEY_MAPNODETYPE] == KEY_MAPNODETYPE_DEFAULT:
			
			add_branches(map_nodes_list, x, 2)
			
	# SPAWN THIRD GENERATION -----------------------------------------------------------------------
	
	for x in map_nodes_list:
		
		if x[KEY_MAPNODE_DEGREE] == 2 and x[KEY_MAPNODETYPE] == KEY_MAPNODETYPE_DEFAULT:
			
			add_branches(map_nodes_list, x, 4)
			
			
	# SPAWN FOURTH GENERATION ----------------------------------------------------------------------
	
	for x in map_nodes_list:
		
		if x[KEY_MAPNODE_DEGREE] == 3 and x[KEY_MAPNODETYPE] == KEY_MAPNODETYPE_DEFAULT:
			
			add_branches(map_nodes_list, x, 8)
			
	# SPAWN FIFTH GENERATION -----------------------------------------------------------------------
	
	for x in map_nodes_list:
		
		if x[KEY_MAPNODE_DEGREE] == 4 and x[KEY_MAPNODETYPE] == KEY_MAPNODETYPE_DEFAULT:
			
			add_branches(map_nodes_list, x, 3)
			
	# SPAWN OBSTACLES AND SOLUTIONS ----------------------------------------------------------------
	
	for x in map_nodes_list:
		if x[KEY_MAPNODE_DEGREE] == 1 and x[KEY_MAPNODETYPE] == KEY_MAPNODETYPE_DEFAULT and x[KEY_MAPNODE_DEPTH] > 3:
			var chance = randf()
			if chance <= obstacle_ratio:
				x[KEY_MAPNODE_REFERENCE].update_texture(map_node_color_obstacle)
				
				var possible_solutions: Array = []
				
				for y in map_nodes_list:
					if y[KEY_MAPNODE_DEGREE] == x[KEY_MAPNODE_DEGREE] and y[KEY_MAPNODETYPE] == KEY_MAPNODETYPE_DEFAULT and y[KEY_MAPNODE_DEPTH] < x[KEY_MAPNODE_DEPTH]:
						possible_solutions.append(y)
				
				var picked_solution = possible_solutions.pick_random()
				picked_solution[KEY_MAPNODE_REFERENCE].update_texture(map_node_color_solution)
				
		elif x[KEY_MAPNODE_DEGREE] > 1 and x[KEY_MAPNODETYPE] == KEY_MAPNODETYPE_DEFAULT:
			var node_type = [KEY_MAPNODETYPE_OBSTACLE, KEY_MAPNODETYPE_SOLUTION, KEY_MAPNODETYPE_EVENT, KEY_MAPNODETYPE_DEFAULT].pick_random()
			
			match node_type:
				KEY_MAPNODETYPE_OBSTACLE:
					x[KEY_MAPNODE_REFERENCE].update_texture(map_node_color_obstacle)
					x[KEY_MAPNODETYPE] = KEY_MAPNODETYPE_OBSTACLE
				KEY_MAPNODETYPE_SOLUTION:
					x[KEY_MAPNODE_REFERENCE].update_texture(map_node_color_solution)
					x[KEY_MAPNODETYPE] = KEY_MAPNODETYPE_SOLUTION
				KEY_MAPNODETYPE_EVENT:
					x[KEY_MAPNODE_REFERENCE].update_texture(map_node_color_event)
					x[KEY_MAPNODETYPE] = KEY_MAPNODETYPE_EVENT
				
	# CHECK OBSTACLES TO SOLUTIONS RATIO -----------------------------------------------------------
	# FOR MAIN PATH ONLY ---------------------------------------------------------------------------
	
	var obstacles_count := 0
	var solutions_count := 0
	
	for x in map_nodes_list:
		if x[KEY_MAPNODE_DEGREE] == 1 and x[KEY_MAPNODETYPE] == KEY_MAPNODETYPE_OBSTACLE:
			obstacles_count += 1
		elif  x[KEY_MAPNODE_DEGREE] == 1 and x[KEY_MAPNODETYPE] == KEY_MAPNODETYPE_SOLUTION:
			solutions_count += 1
			
	if obstacles_count > solutions_count: print("NOT ENOUGH SOLUTIONS!")
			
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
					
					if is_distant_enough == true and target_position.distance_to(middle_point) < distance_from_middle_point:
						add_child(new_node)
						# add_child(edge_line)
						has_been_positioned = true
						
						add_to_map_nodes_list(list, target_position, starting[KEY_MAPNODE_DEGREE]+1, starting[KEY_MAPNODE_DEPTH], new_node)

	
	
func pick_random_distance() -> int:
	return [short_walk_length, medium_walk_length, long_walk_length].pick_random()

func add_to_map_nodes_list(list: Array, pos: Vector2, degree: int, depth: int, ref: Node2D, type:=KEY_MAPNODETYPE_DEFAULT) -> void:
	var map_node_data := {
		KEY_MAPNODE_POS: pos,
		KEY_MAPNODE_DEGREE: degree,
		KEY_MAPNODE_DEPTH: depth,
		KEY_MAPNODETYPE: type,
		KEY_MAPNODE_REFERENCE: ref
	}
	list.append(map_node_data)

func check_distance(list: Array, current_point: Vector2, distance: int) -> bool:
	var is_distant_enough := true
	for x in list:
		if current_point.distance_to(x[KEY_MAPNODE_POS]) < distance:
			is_distant_enough = false
	
	return is_distant_enough

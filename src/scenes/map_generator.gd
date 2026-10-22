extends Node

# WALD MAP GENERATOR -------------------------------------------------------------------------------
# Generate nodes layout, define node types, store into a JSON --------------------------------------


# MAIN VARIABLES -----------------------------------------------------------------------------------
@export var map_depth: int = 10
@export var branching_degrees: int = 3
@export var branching_probability := 0.6
@export var branching_multiplier := 3

@export_enum("Easy", "Medium", "Hard") var difficulty: int

@export var short_walk_length := 200
@export var medium_walk_length := 400
@export var long_walk_length := 600

var map_nodes_list: Array = []

var start_coords: Vector2 = Vector2.ZERO
var finish_coords: Vector2
var midpoint: Vector2 # The midpoint between the start and finish nodes, used for cleanup
var map_radius: int # The radius of the map, used to bound node generation to its insides


# STEPS --------------------------------------------------------------------------------------------
func _ready() -> void:
	generate_main_path(map_depth)
	_calculate_midpoint()
	generate_branches(branching_degrees)
	populate_map(difficulty)
	SignalBus.finished_generating_map.emit(map_nodes_list) # Send the map data to the visualizer


# GENERATOR ----------------------------------------------------------------------------------------
func generate_main_path(depth: int) -> void:
	# Generates the main series of nodes at Degree 1 and increasing Depth
	
	_store_node(
		start_coords, 
		1, 
		1, 
		Definitions.KEY_MAPNODETYPE_START, 
		start_coords
		)
	
	var origin: Vector2 = start_coords
	
	for d in depth:
		
		var angle = randi_range(-80, 80)
		var distance: int
		
		if d < 4: # Makes sure the first 3 nodes are at a short walking distance
			distance = short_walk_length
		else:
			distance = _pick_random_distance()
		
		var target_position = Vector2.from_angle(deg_to_rad(angle))*distance+origin
		
		_store_node(
			target_position, 
			1,
			d, 
			Definitions.KEY_MAPNODETYPE_DEFAULT, 
			origin
			)
		
		origin = target_position # The new origin of the loop is the newly defined node
	
	# When the loop is ended, we change the last node to type finish
	map_nodes_list[map_nodes_list.size()-1][Definitions.KEY_MAPNODETYPE] = Definitions.KEY_MAPNODETYPE_FINISH
	finish_coords = map_nodes_list[map_nodes_list.size()-1][Definitions.KEY_MAPNODE_POS] 


func generate_branches(degrees) -> void:
	for degree in degrees:
		for node in map_nodes_list:
			if node[Definitions.KEY_MAPNODE_DEGREE] == degree + 1 and node[Definitions.KEY_MAPNODETYPE] == Definitions.KEY_MAPNODETYPE_DEFAULT:
				spawn_branches(node, (degree+1)*(1+branching_multiplier))


func spawn_branches(branches_origin, branches_amt) -> void:
	var branches_found: int = 0
	
	var starting_angle: int = randi_range(-360,360)
	
	for angle in 360/5:
		# Attempt to spawn a new node, at all distance options. Proceed when found
		if branches_found == branches_amt: break
		var space_found: bool = false
		
		# Using the origin, cast a point at long distance and right angle
		var target_position = Vector2.from_angle(deg_to_rad(starting_angle+(angle*5))) * long_walk_length + branches_origin[Definitions.KEY_MAPNODE_POS]
		
		if is_distant(target_position, short_walk_length): 
			space_found = true
			branches_found += 1
		
		if space_found == false: # If not found at long distance, try again at medium distance
			target_position = Vector2.from_angle(deg_to_rad(starting_angle+(angle*5))) * medium_walk_length + branches_origin[Definitions.KEY_MAPNODE_POS]
			
			if is_distant(target_position, medium_walk_length):
				space_found = true
				branches_found += 1
		
		if space_found == false: # If not found either at long or medium distance, try again at short distance
			target_position = Vector2.from_angle(deg_to_rad(starting_angle+(angle*5))) * short_walk_length + branches_origin[Definitions.KEY_MAPNODE_POS]
			
			if is_distant(target_position, long_walk_length):
				space_found = true
				branches_found += 1
				
		if space_found == true: # If found, add last known position to the nodes list
			
			var roll_for_branches: float = randf()
			if roll_for_branches < branching_probability:
				_store_node(
					target_position, 
					branches_origin[Definitions.KEY_MAPNODE_DEGREE] + 1, 
					branches_origin[Definitions.KEY_MAPNODE_DEPTH], 
					Definitions.KEY_MAPNODETYPE_DEFAULT, 
					branches_origin[Definitions.KEY_MAPNODE_POS]
					)


func populate_map(diff: int) -> void:
	# Add long distance walker in the first 3 degree 1 things
	var random_long_walker: int = [1,2,3].pick_random()
	map_nodes_list[random_long_walker][Definitions.KEY_MAPNODETYPE] = Definitions.KEY_MAPNODETYPE_SOLUTION
	
	# Edit generation parameters by difficulty
	var obstacles_ratio: float
	match diff:
		0:
			obstacles_ratio = 0.3
		1:
			obstacles_ratio = 0.4
		2:
			obstacles_ratio = 0.5
	
	# MAIN PATH OBSTACLES AND SOLUTIONS ------------------------------------------------------------
	for node in map_nodes_list:
		if node[Definitions.KEY_MAPNODE_DEGREE] == 1 and node[Definitions.KEY_MAPNODETYPE] == Definitions.KEY_MAPNODETYPE_DEFAULT and node[Definitions.KEY_MAPNODE_DEPTH] > 3:
			var roll_for_obstacle: float = randf()
			if roll_for_obstacle < obstacles_ratio:
				
				node[Definitions.KEY_MAPNODETYPE] = Definitions.KEY_MAPNODETYPE_OBSTACLE
				
				var possible_solutions: Array = []
				for possible_node in map_nodes_list:
					if possible_node[Definitions.KEY_MAPNODE_DEGREE] == node[Definitions.KEY_MAPNODE_DEGREE] and possible_node[Definitions.KEY_MAPNODETYPE] == Definitions.KEY_MAPNODETYPE_DEFAULT and possible_node[Definitions.KEY_MAPNODE_DEPTH] < node[Definitions.KEY_MAPNODE_DEPTH]:
						possible_solutions.append(possible_node)
						
				var picked_node_for_solution = possible_solutions.pick_random()
				
				picked_node_for_solution[Definitions.KEY_MAPNODETYPE] = Definitions.KEY_MAPNODETYPE_SOLUTION # TODO: sometimes this crashes everything
	
	# REST OF THE MAP OBSTACLES AND SOLUTIONS ------------------------------------------------------
		elif node[Definitions.KEY_MAPNODE_DEGREE] > 1 and node[Definitions.KEY_MAPNODETYPE] == Definitions.KEY_MAPNODETYPE_DEFAULT:
			var roll_for_obstacle: float = randf()
			if roll_for_obstacle < obstacles_ratio:
				node[Definitions.KEY_MAPNODETYPE] = Definitions.KEY_MAPNODETYPE_OBSTACLE
				
				var possible_solutions: Array = []
				for possible_node in map_nodes_list:
					if possible_node[Definitions.KEY_MAPNODETYPE] == Definitions.KEY_MAPNODETYPE_DEFAULT:
						possible_solutions.append(possible_node)
						
				var picked_node_for_solution = possible_solutions.pick_random()
				
				picked_node_for_solution[Definitions.KEY_MAPNODETYPE] = Definitions.KEY_MAPNODETYPE_SOLUTION
				
	# THEN THE REST OF THE DEFAULT NODES GET CONVERTED INTO EVENTS ---------------------------------
	for node in map_nodes_list:
		if node[Definitions.KEY_MAPNODETYPE] == Definitions.KEY_MAPNODETYPE_DEFAULT:
			node[Definitions.KEY_MAPNODETYPE] = Definitions.KEY_MAPNODETYPE_EVENT

func _pick_random_distance() -> int:
	return [short_walk_length, medium_walk_length, long_walk_length].pick_random()

func _calculate_midpoint() -> void:
	midpoint = ((finish_coords - start_coords) / 2 + start_coords)
	map_radius = midpoint.distance_to(start_coords)
	

func _store_node(pos: Vector2, degree: int, depth: int, type: String, prev_coords: Vector2 = Vector2.ZERO) -> void:
	var map_node_data := {
		Definitions.KEY_MAPNODE_POS: pos,
		Definitions.KEY_MAPNODE_DEGREE: degree,
		Definitions.KEY_MAPNODE_DEPTH: depth,
		Definitions.KEY_MAPNODETYPE: type,
		Definitions.KEY_PREVIOUSNODE_COORDS: prev_coords
	}
	map_nodes_list.append(map_node_data)

func is_distant(current_point: Vector2, distance: int) -> bool:
	# Check if the provided coordinates are a provided distance away from all other points in a list
	var is_distant_enough := true
	for x in map_nodes_list:
		if current_point.distance_to(x[Definitions.KEY_MAPNODE_POS]) < distance or current_point.distance_to(midpoint) > map_radius:
			is_distant_enough = false
	
	return is_distant_enough

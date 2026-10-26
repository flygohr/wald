extends Node

# WALD MAP GENERATOR -------------------------------------------------------------------------------
# Generate nodes layout, define node types, store into a JSON --------------------------------------


# MAIN VARIABLES -----------------------------------------------------------------------------------
# TODO: Easy for the jam. Later, define difficulty options and relative parameters.
@export var map_depth: int = 10
@export var branching_degrees: int = 3
@export var branching_probability := 0.6
@export var branching_multiplier := 3
@export var safe_depth: int = 3 # Where to spawn long distance walker, keep short distance, don't add obstacles

@export_enum("Easy", "Medium", "Hard") var difficulty: int

@export var boundaries_offset := 400

var map_nodes_list: Array = []

var start_coords: Vector2 = Vector2.ZERO
var finish_coords: Vector2
var midpoint: Vector2 # The midpoint between the start and finish nodes, used for cleanup
var map_radius: int # The radius of the map, used to bound node generation to its insides

func _ready() -> void:
	# SignalBus.generate_new_map.connect(generate_map)
	if GameData.current[GameData.KEY_IS_NEW_GAME] == true:
		generate_map()

# STEPS --------------------------------------------------------------------------------------------
func generate_map() -> void:
	generate_main_path(map_depth)
	_calculate_midpoint()
	generate_branches(branching_degrees)
	_calculate_boundaries()
	populate_map(difficulty)
	GameData.current[GameData.KEY_MAP_NODES_DATA] = map_nodes_list
	GameData.current[GameData.KEY_IS_NEW_GAME] = false
	GameData.initiate_save_game_data()


# GENERATOR ----------------------------------------------------------------------------------------
func generate_main_path(depth: int) -> void:
	# Generates the main series of nodes at Degree 1 and increasing Depth
	
	_store_node(
		start_coords, 
		1, 
		0, 
		GameData.KEY_MAPNODETYPE_START, 
		start_coords
		)
	
	var origin: Vector2 = start_coords
	
	for d in depth:
		
		var angle = randi_range(-80, 80)
		var distance: int
		
		if d <= safe_depth: # Makes sure the first X nodes are at a short walking distance
			distance = GameData.SHORT_WALK_DISTANCE
		else:
			distance = _pick_random_distance()
		
		var target_position = Vector2.from_angle(deg_to_rad(angle))*distance+origin
		
		_store_node(
			target_position, 
			1,
			d+1, 
			GameData.KEY_MAPNODETYPE_DEFAULT, 
			origin
			)
		
		origin = target_position # The new origin of the loop is the newly defined node
	
	# When the loop is ended, we change the last node to type finish
	map_nodes_list[map_nodes_list.size()-1][GameData.KEY_MAPNODETYPE] = GameData.KEY_MAPNODETYPE_FINISH
	finish_coords = map_nodes_list[map_nodes_list.size()-1][GameData.KEY_MAPNODE_POS] 


func generate_branches(degrees) -> void:
	for degree in degrees:
		for node in map_nodes_list:
			if node[GameData.KEY_MAPNODE_DEGREE] == degree + 1 and node[GameData.KEY_MAPNODETYPE] == GameData.KEY_MAPNODETYPE_DEFAULT:
				spawn_branches(node, (degree+1)*(1+branching_multiplier))


func spawn_branches(branches_origin, branches_amt) -> void:
	var branches_found: int = 0
	
	var starting_angle: int = randi_range(-360,360)
	
	for angle in 360/5:
		# Attempt to spawn a new node, at all distance options. Proceed when found
		if branches_found == branches_amt: break
		var space_found: bool = false
		
		# Using the origin, cast a point at long distance and right angle
		var target_position = Vector2.from_angle(deg_to_rad(starting_angle+(angle*5))) * GameData.LONG_WALK_DISTANCE + branches_origin[GameData.KEY_MAPNODE_POS]
		
		if is_distant(target_position, GameData.LONG_WALK_DISTANCE): 
			space_found = true
			branches_found += 1
		
		if space_found == false: # If not found at long distance, try again at medium distance
			target_position = Vector2.from_angle(deg_to_rad(starting_angle+(angle*5))) * GameData.MEDIUM_WALK_DISTANCE + branches_origin[GameData.KEY_MAPNODE_POS]
			
			if is_distant(target_position, GameData.MEDIUM_WALK_DISTANCE):
				space_found = true
				branches_found += 1
		
		if space_found == false: # If not found either at long or medium distance, try again at short distance
			target_position = Vector2.from_angle(deg_to_rad(starting_angle+(angle*5))) * GameData.SHORT_WALK_DISTANCE + branches_origin[GameData.KEY_MAPNODE_POS]
			
			if is_distant(target_position, GameData.SHORT_WALK_DISTANCE):
				space_found = true
				branches_found += 1
				
		if space_found == true: # If found, add last known position to the nodes list
			
			var roll_for_branches: float = randf()
			if roll_for_branches < branching_probability:
				_store_node(
					target_position, 
					branches_origin[GameData.KEY_MAPNODE_DEGREE] + 1, 
					branches_origin[GameData.KEY_MAPNODE_DEPTH], 
					GameData.KEY_MAPNODETYPE_DEFAULT, 
					branches_origin[GameData.KEY_MAPNODE_POS]
					)


func populate_map(diff: int) -> void:
	# LONG DISTANCE WALKER -------------------------------------------------------------------------
	# Add long distance walker in the first 3 degree 1 things
	var safe_nodes_indexes: Array = []
	for x in range(safe_depth):
		safe_nodes_indexes.append(x+1)
	var random_long_walker: int = safe_nodes_indexes.pick_random()
	map_nodes_list[random_long_walker][GameData.KEY_MAPNODETYPE] = GameData.KEY_MAPNODETYPE_SOLUTION
	
	
	# MAIN PATH OBSTACLES AND SOLUTIONS ------------------------------------------------------------
	var max_number_of_obstacles: int = floor((map_depth-3)/2) # This way, I can assure that the first 3 nodes are free AND that there's always room for solutions
	var current_number_of_obstacles: int = 0
	var obstacles_ratio: float = 0.5
	
	var main_path_nodes: Array = []
	for node in map_nodes_list:
		if (
			node[GameData.KEY_MAPNODE_DEGREE] == 1 and 
			node[GameData.KEY_MAPNODETYPE] == GameData.KEY_MAPNODETYPE_DEFAULT and 
			node[GameData.KEY_MAPNODE_DEPTH] > safe_depth
			):
				main_path_nodes.append(node)
	
	for i in range(main_path_nodes.size()-1, 0, -1): # We skip the last to leave one empty for solutions
		print(main_path_nodes[i])
		var roll_for_obstacle: float = randf()
		if (
			roll_for_obstacle < obstacles_ratio and 
			current_number_of_obstacles <= max_number_of_obstacles
			):
				var possible_solutions: Array = []
				for remaining_node in main_path_nodes:
					if (
						remaining_node[GameData.KEY_MAPNODETYPE] == GameData.KEY_MAPNODETYPE_DEFAULT and # Solution must be a free node
						remaining_node[GameData.KEY_MAPNODE_DEPTH] < main_path_nodes[i][GameData.KEY_MAPNODE_DEPTH] # Solution must come before 
						):
						possible_solutions.append(remaining_node)
				
				if possible_solutions.size() >= 1: # Check if there's enough space left to add an obstacle + solution
					main_path_nodes[i][GameData.KEY_MAPNODETYPE] = GameData.KEY_MAPNODETYPE_OBSTACLE
					current_number_of_obstacles += 1
					var picked_node_for_solution = possible_solutions.pick_random()
					picked_node_for_solution[GameData.KEY_MAPNODETYPE] = GameData.KEY_MAPNODETYPE_SOLUTION 
	
	# REST OF THE MAP OBSTACLES AND SOLUTIONS ------------------------------------------------------
	for node in map_nodes_list:
		if (
			node[GameData.KEY_MAPNODE_DEGREE] > 1 and 
			node[GameData.KEY_MAPNODETYPE] == GameData.KEY_MAPNODETYPE_DEFAULT
			):
				var roll_for_obstacle: float = randf()
				if roll_for_obstacle < obstacles_ratio:
					node[GameData.KEY_MAPNODETYPE] = GameData.KEY_MAPNODETYPE_OBSTACLE
					
					var possible_solutions: Array = []
					for possible_node in map_nodes_list:
						if possible_node[GameData.KEY_MAPNODETYPE] == GameData.KEY_MAPNODETYPE_DEFAULT:
							possible_solutions.append(possible_node)
							
					var picked_node_for_solution = possible_solutions.pick_random()
					
					picked_node_for_solution[GameData.KEY_MAPNODETYPE] = GameData.KEY_MAPNODETYPE_SOLUTION
				
	# THEN THE REST OF THE DEFAULT NODES GET CONVERTED INTO EVENTS ---------------------------------
	for node in map_nodes_list:
		if node[GameData.KEY_MAPNODETYPE] == GameData.KEY_MAPNODETYPE_DEFAULT:
			node[GameData.KEY_MAPNODETYPE] = GameData.KEY_MAPNODETYPE_EVENT

func _pick_random_distance() -> int:
	return [GameData.SHORT_WALK_DISTANCE, GameData.MEDIUM_WALK_DISTANCE, GameData.LONG_WALK_DISTANCE].pick_random()

func _calculate_midpoint() -> void:
	midpoint = ((finish_coords - start_coords) / 2 + start_coords)
	map_radius = midpoint.distance_to(start_coords)

func _calculate_boundaries() -> void:
	
	var left_bound: int = 0
	var top_bound: int = 0
	var right_bound: int = 0
	var bottom_bound: int = 0
	
	for node in map_nodes_list:
		if node[GameData.KEY_MAPNODE_POS].y < top_bound: top_bound = node[GameData.KEY_MAPNODE_POS].y
		if node[GameData.KEY_MAPNODE_POS].x > right_bound: right_bound = node[GameData.KEY_MAPNODE_POS].x
		if node[GameData.KEY_MAPNODE_POS].y > bottom_bound: bottom_bound = node[GameData.KEY_MAPNODE_POS].y
		if node[GameData.KEY_MAPNODE_POS].x < left_bound: left_bound = node[GameData.KEY_MAPNODE_POS].x
		
	var extended_left_bound: int = left_bound - boundaries_offset
	var extended_top_bound: int = top_bound - boundaries_offset
	var extended_right_bound: int = right_bound + boundaries_offset
	var extended_bottom_bound: int = bottom_bound + boundaries_offset
	
	GameData.current[GameData.KEY_MAP_BOUNDARIES][GameData.KEY_LEFT_X] = extended_left_bound
	GameData.current[GameData.KEY_MAP_BOUNDARIES][GameData.KEY_TOP_Y] = extended_top_bound
	GameData.current[GameData.KEY_MAP_BOUNDARIES][GameData.KEY_RIGHT_X] = extended_right_bound
	GameData.current[GameData.KEY_MAP_BOUNDARIES][GameData.KEY_BOTTOM_Y] = extended_bottom_bound
	
	GameData.initiate_save_game_data()

func _store_node(pos: Vector2, degree: int, depth: int, type: String, prev_coords: Vector2 = Vector2.ZERO) -> void:
	var map_node_data := {
		GameData.KEY_MAPNODE_ID: 0,
		GameData.KEY_MAPNODE_POS: pos,
		GameData.KEY_MAPNODE_DEGREE: degree,
		GameData.KEY_MAPNODE_DEPTH: depth,
		GameData.KEY_MAPNODETYPE: type,
		GameData.KEY_PREVIOUSNODE_COORDS: prev_coords
	}
	map_nodes_list.append(map_node_data)

func is_distant(current_point: Vector2, distance: int) -> bool:
	# Check if the provided coordinates are a provided distance away from all other points in a list
	var is_distant_enough := true
	for x in map_nodes_list:
		if current_point.distance_to(x[GameData.KEY_MAPNODE_POS]) < distance or current_point.distance_to(midpoint) > map_radius:
			is_distant_enough = false
	
	return is_distant_enough

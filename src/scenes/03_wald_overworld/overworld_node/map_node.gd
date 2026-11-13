extends Node2D
class_name MapNode

#TODO: node needs to do different things depending on what it is
# if revealed, show icon, not general white dot
# if highlighted, show highlight animation
# if end, show finish arrow and offscreen indicator

@export var color : Color
@export var node_radius := 25
@export var dashed_line_scene: PackedScene
#@export var navigator_scene: PackedScene

var temporary_dashed_line: Line2D

@onready var active_marker: Sprite2D = $ActiveMarker
@onready var check_button: TextureButton = $CheckButton
@onready var node_icon: Sprite2D = $NodeIcon

@onready var debug_label: Label = $DebugLabel

@export var undiscovered_icon: Texture2D
@export var clearing_icon: Texture2D
@export var ruins_icon: Texture2D
@export var springs_icon: Texture2D
@export var chasm_icon: Texture2D
@export var rapids_icon: Texture2D
@export var start_icon: Texture2D
@export var end_icon: Texture2D


var index: int:
	set(value):
		index = value
		queue_redraw()
		update_node()
	
var is_active: bool = false:
	set(value):
		is_active = value
		display_active_marker(value)
		queue_redraw()

var is_selected: bool = false:
	set(value):
		is_selected = value
		queue_redraw()

var active_radius: int = 40

var selected_radius: int:
	set(value):
		selected_radius = value
		queue_redraw()

var _time: float = 0

var current_color: Color:
	set(value):
		current_color = value
		queue_redraw()

var is_cleared: bool = false:
	set(value):
		is_cleared = value
		queue_redraw()
		update_node()
		
var is_visited: bool = false:
	set(value):
		is_visited = value
		queue_redraw()


var is_finish: bool = false:
	set(value):
		is_finish = value
		queue_redraw()

var finish_radius: int

var incoming_is_cleared: bool = true:
	set(value):
		incoming_is_cleared = value
		queue_redraw()
		
var node_data: Dictionary = {}

func _ready() -> void:
	SignalBus.new_active_node_set.connect(_check_if_active)
	SignalBus.moved_around_the_map.connect(_unselect_this)
	SignalBus.traveled_to.connect(_check_if_traveled_to)
	SignalBus.node_selected.connect(_check_if_still_selected)
	
	var button_size = (node_radius * 2) + 10
	check_button.size = Vector2(button_size, button_size)
	check_button.position = Vector2(-(button_size/2), -(button_size/2))

	update_node()


func update_index(i: int) -> void:
	index = i

func _process(delta: float) -> void:

	selected_radius = remap(sin(_time * TAU), -1.0, 1.0, node_radius+20, node_radius+40)

	finish_radius = remap(sin(_time * TAU), -1.0, 1.0, node_radius+10, node_radius+30)
		
	_time += delta


func _draw() -> void:
	draw_circle(
		Vector2.ZERO, 
		node_radius, 
		Color.WHITE, 
		true, 
		-1.0, 
		true)
	
	if is_selected and is_active == false and incoming_is_cleared == true:
		draw_circle(Vector2.ZERO, selected_radius, Color.WHITE, false, 5, false)
	elif is_selected and is_active == false and incoming_is_cleared == false:
		draw_circle(Vector2.ZERO, selected_radius, Color("c34040ff"), false, 5, false)
	
	if is_cleared == false and is_visited == true:
		draw_circle(Vector2.ZERO, node_radius, Color("c34040ff"), false, 10, false)	
	elif is_cleared == true and is_visited == true:
		draw_circle(Vector2.ZERO, node_radius, Color("78d45bff"), false, 10, false)
		
	if is_active:
		draw_circle(Vector2.ZERO, active_radius, Color.WHITE, false, 5, false)
	
	if is_finish:
		draw_circle(Vector2.ZERO, finish_radius, Color("2b78bbff"), false, 5, false)
	
func update_node() -> void:
	
	node_data = GameData.current[GameData.KEY_MAP_NODES_DATA][index]
	
	match node_data[GameData.KEY_MAPNODETYPE]:
		GameData.KEY_MAPNODETYPE_START:
			node_icon.texture = start_icon
		GameData.KEY_MAPNODETYPE_CLEARING:
			node_icon.texture = clearing_icon
		GameData.KEY_MAPNODETYPE_RUINS:
			node_icon.texture = ruins_icon
		GameData.KEY_MAPNODETYPE_SPRINGS:
			node_icon.texture = springs_icon
		GameData.KEY_MAPNODETYPE_CHASM:
			node_icon.texture = chasm_icon
		GameData.KEY_MAPNODETYPE_RAPIDS:
			node_icon.texture = rapids_icon
		GameData.KEY_MAPNODETYPE_FINISH:
			is_finish = true 
			node_icon.texture = end_icon
			#var navigator = navigator_scene.instantiate()
			#add_child(navigator)
	if GameData.is_debug == true:
		debug_label.show()
		debug_label.text = str(node_data[GameData.KEY_MAPNODEFEATURE])
	
	#if is_cleared == false:
		#node_icon.texture = load("res://assets/images/icons/Wald_Assets_Icons_BW.png")
	#else:
		#node_icon.texture = load("res://assets/images/icons/Wald_Assets_Icons.png")
		

func display_active_marker(toggle: bool) -> void:
	if toggle == true:
		active_marker.show()
	else:
		active_marker.hide()

# TODO: if finish type, add red target marker, and arrow pointing
# TODO: instead of instantly teleport, display a popup with a button asking if move or not, showing cost of travel
# TODO: add dotted line between two cleared points
# TODO: add button to clear node
# TODO: draw another line, a full one, to mark completed connections instead of just dotted line
# TODO: node icon will also be modulated to greyscale if not yet completed
# TODO: icon has two layers. icon on top, always color or question mark. bg is like tokens for vtt, same edge, but inside is green for cleared, red for not cleared, grey for undiscovered


func _check_if_active(i) -> void:
	if i == index:
		is_active = true
	else:
		is_active = false
		queue_redraw()


func _on_check_button_pressed() -> void:
	# Check if is close enough to the active node
	if global_position.distance_to(GameData.current[GameData.KEY_MAP_NODES_DATA][GameData.current[GameData.KEY_MAP_CURRENT_NODE_INDEX]][GameData.KEY_MAPNODE_POS]) <= GameData.current[GameData.KEY_CURRENT_WALKING_DISTANCE] + 50:
		_select_this()

func _check_if_traveled_to(from: int, to: int) -> void:
	if to == index:
		is_active = true
		_erase_temporary_line()
		is_selected = false
		
		GameData.current[GameData.KEY_MAP_NODES_DATA][to][GameData.KEY_INCOMING_CONNECTIONS].append(from)


func _check_if_still_selected(i: int) -> void:
	if i != index: _unselect_this()


func _select_this() -> void:
	var is_centered: bool
	if GameData.camera_position.distance_to(global_position) <= node_radius:
		is_centered = true
	else:
		is_centered = false
		
	
	if is_active == true and is_centered == true:
		GameData.is_inside_node = true
		GameData.initiate_save_game_data()
		ScenesManager.load_scene(ScenesManager.SCENE_PATHS[ScenesManager.KEY_INSIDE_NODE_SCREEN])
	elif is_active == true and is_centered == false:
		SignalBus.pan_to.emit(global_position)
	else:
		SignalBus.pan_to.emit(global_position)
		if GameData.current[GameData.KEY_MAP_NODES_DATA][GameData.current[GameData.KEY_MAP_CURRENT_NODE_INDEX]][GameData.KEY_IS_CLEARED] == false and GameData.current[GameData.KEY_MAP_NODES_DATA][GameData.current[GameData.KEY_MAP_CURRENT_NODE_INDEX]][GameData.KEY_INCOMING_CONNECTIONS].has(index) == false:
			_draw_temporary_line(GameData.current[GameData.KEY_MAP_NODES_DATA][GameData.current[GameData.KEY_MAP_CURRENT_NODE_INDEX]][GameData.KEY_MAPNODE_POS], global_position, false)
			#TODO: if in incoming connections, allow it
		else: _draw_temporary_line(GameData.current[GameData.KEY_MAP_NODES_DATA][GameData.current[GameData.KEY_MAP_CURRENT_NODE_INDEX]][GameData.KEY_MAPNODE_POS], global_position, true)
		is_selected = true
		SignalBus.node_selected.emit(index)
		
		
		
		var distance_in_days: int = roundi(global_position.distance_to(GameData.current[GameData.KEY_MAP_NODES_DATA][GameData.current[GameData.KEY_MAP_CURRENT_NODE_INDEX]][GameData.KEY_MAPNODE_POS]) / 100) 
		var difficulty_multiplier: float = GameData.current[GameData.KEY_MAP_NODES_DATA][index][GameData.KEY_MAPNODE_RNGV]
		
		var food_cost: int = int(GameData.BASE_FOOD_PER_DAY * distance_in_days * difficulty_multiplier)
		var sanity_cost: int = int(GameData.BASE_SANITY_PER_DAY * distance_in_days * difficulty_multiplier)
		
		SignalBus.action_prompt_created.emit(
			{
				# Emit selected node type
				ActionsData.KEY_NAME: GameData.current[GameData.KEY_MAP_NODES_DATA][index][GameData.KEY_MAPNODETYPE],
				# Emit icon texture
				ActionsData.KEY_ICON: ActionsData.PROMPT_ICONS[ActionsData.ICON_TRAVEL],
				# Emit costs
				ActionsData.KEY_COSTS: [
					{ActionsData.KEY_COST_ICON: ActionsData.PROMPT_ICONS[ActionsData.ICON_SANITY], ActionsData.KEY_COST_VALUE: sanity_cost}, #TODO: calculate based on distance + party members + rng
					{ActionsData.KEY_COST_ICON: ActionsData.PROMPT_ICONS[ActionsData.ICON_FOOD], ActionsData.KEY_COST_VALUE: food_cost}, #TODO: calculate based on distance + party members + rng
				],
				# Emit button text
				ActionsData.KEY_BUTTON_TEXT: "Travel",
				# Emit result
				ActionsData.KEY_RESULT: [
					{ActionsData.KEY_RESULT_TYPE: ActionsData.KEY_RESULT_TRAVEL,
					ActionsData.KEY_RESULT_VALUE: index}
				]
			}
		)

func _unselect_this() -> void:
	is_selected = false
	_erase_temporary_line()


func _draw_temporary_line(s: Vector2, e: Vector2, valid: bool = false) -> void:
	temporary_dashed_line = dashed_line_scene.instantiate()
	temporary_dashed_line.add_point(s)
	temporary_dashed_line.add_point(e)
	temporary_dashed_line.z_index = 0
	temporary_dashed_line.z_as_relative = false
	add_child(temporary_dashed_line)
	if valid == false:
		temporary_dashed_line.render_not_valid()
		incoming_is_cleared = false
	temporary_dashed_line.global_position = Vector2.ZERO


func _erase_temporary_line() -> void:
	if temporary_dashed_line != null:
		temporary_dashed_line.queue_free()

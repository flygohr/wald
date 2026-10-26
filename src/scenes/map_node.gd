extends Node2D

#TODO: node needs to do different things depending on what it is
# if revealed, show icon, not general white dot
# if highlighted, show highlight animation
# if end, show finish arrow and offscreen indicator

@export var color : Color
@export var node_radius := 25

const COLOR_START: Color = Color.GREEN
const COLOR_FINISH: Color = Color.BLUE

const COLOR_DEFAULT: Color = Color.WEB_GRAY

const COLOR_OBSTACLE: Color = Color.DARK_RED
const COLOR_SOLUTION: Color = Color.ORANGE
const COLOR_EVENT: Color = Color.WEB_PURPLE

@onready var check_button: TextureButton = $CheckButton

var index: int = 0
var is_active: bool = false

var active_radius: int:
	set(value):
		active_radius = value
		queue_redraw()
var _time: float = 0

var current_color: Color:
	set(value):
		current_color = value
		queue_redraw()


func _ready() -> void:
	SignalBus.new_active_node_set.connect(_check_if_active)
	var button_size = (node_radius * 2) + 10
	check_button.size = Vector2(button_size, button_size)
	check_button.position = Vector2(-(button_size/2), -(button_size/2))
	current_color = COLOR_DEFAULT


func _process(delta: float) -> void:
	if is_active:
		active_radius = remap(sin(_time * TAU), -1.0, 1.0, node_radius+20, node_radius+40)
		_time += delta


func _draw() -> void:
	draw_circle(
		Vector2.ZERO, 
		node_radius, 
		current_color, 
		true, 
		-1.0, 
		true)
	
	if is_active:
		draw_circle(Vector2.ZERO, active_radius, Color.WHITE, false, 5, true)


func _check_if_active(i) -> void:
	if i == index:
		is_active = true
		set_process(true)
	else:
		is_active = false
		set_process(false)
		queue_redraw()

func update_color(type: String) -> void:
	match type:
		GameData.KEY_MAPNODETYPE_START:
			current_color = COLOR_START
		GameData.KEY_MAPNODETYPE_FINISH:
			current_color = COLOR_FINISH
		GameData.KEY_MAPNODETYPE_OBSTACLE:
			current_color = COLOR_OBSTACLE
		GameData.KEY_MAPNODETYPE_SOLUTION:
			current_color = COLOR_SOLUTION
		GameData.KEY_MAPNODETYPE_EVENT:
			current_color = COLOR_EVENT
		_:
			current_color = COLOR_DEFAULT


func _on_check_button_pressed() -> void:
	print("I'm node index ", index)
	SignalBus.debug_travel.emit(index) # TODO: emit this node's index instead!

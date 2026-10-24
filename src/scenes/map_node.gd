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

var current_color: Color:
	set(value):
		current_color = value
		queue_redraw()

func _ready() -> void:
	var button_size = (node_radius * 2) + 10
	check_button.size = Vector2(button_size, button_size)
	check_button.position = Vector2(-(button_size/2), -(button_size/2))
	current_color = COLOR_DEFAULT

func _draw() -> void:
	draw_circle(
		Vector2.ZERO, 
		node_radius, 
		current_color, 
		true, 
		-1.0, 
		true)

func update_color(type: String) -> void:
	
	await ready
	
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
	SignalBus.debug_travel.emit(global_position)

extends Node2D

#TODO: node needs to do different things depending on what it is
# if revealed, show icon, not general white dot
# if highlighted, show highlight animation
# if end, show finish arrow and offscreen indicator

@export var color : Color
@export var scale_mult := 0.03

const COLOR_START: Color = Color.GREEN
const COLOR_FINISH: Color = Color.BLUE

const COLOR_DEFAULT: Color = Color.WEB_GRAY

const COLOR_OBSTACLE: Color = Color.DARK_RED
const COLOR_SOLUTION: Color = Color.ORANGE
const COLOR_EVENT: Color = Color.WEB_PURPLE

@onready var node_sprite: Sprite2D = $NodeSprite

func update_texture(type: String) -> void:
	
	await ready
	
	match type:
		Definitions.KEY_MAPNODETYPE_START:
			node_sprite.modulate = COLOR_START
		Definitions.KEY_MAPNODETYPE_FINISH:
			node_sprite.modulate = COLOR_FINISH
		Definitions.KEY_MAPNODETYPE_OBSTACLE:
			node_sprite.modulate = COLOR_OBSTACLE
		Definitions.KEY_MAPNODETYPE_SOLUTION:
			node_sprite.modulate = COLOR_SOLUTION
		Definitions.KEY_MAPNODETYPE_EVENT:
			node_sprite.modulate = COLOR_EVENT
		_:
			node_sprite.modulate = COLOR_DEFAULT
	

func _on_check_button_pressed() -> void:
	SignalBus.debug_travel.emit(global_position)

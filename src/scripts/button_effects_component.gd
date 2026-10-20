extends Node
class_name ButtonEffectsComponent

@export var ease_type: Tween.EaseType
@export var transition_type: Tween.TransitionType
@export var animation_duration: float = 0.1
@export var scale_amount: Vector2 = Vector2(1.0,1.0)
@export var rotation_amount: float = 0.0
@export var outline_color: Color = Color("eeecde")

@onready var button: Button = get_parent()

var tween: Tween
#TODO: learn how to use shaders in the future 
var background_topside: ColorRect
var background_rightside: ColorRect
var background_bottomside: ColorRect
var background_leftside: ColorRect

func _ready() -> void:
	button.mouse_entered.connect(_on_mouse_hovered.bind(true))
	button.mouse_exited.connect(_on_mouse_hovered.bind(false))
	
	background_topside  = ColorRect.new()
	background_rightside  = ColorRect.new()
	background_bottomside  = ColorRect.new()
	background_leftside  = ColorRect.new()
	
	recalculate_outline_size(background_topside, background_rightside, background_bottomside, background_leftside)
	
	background_topside.color = Color(1.0, 1.0, 1.0, 0.0)
	background_rightside.color = Color(1.0, 1.0, 1.0, 0.0)
	background_bottomside.color = Color(1.0, 1.0, 1.0, 0.0)
	background_leftside.color = Color(1.0, 1.0, 1.0, 0.0)
	
	button.add_child.call_deferred(background_topside)
	button.add_child.call_deferred(background_rightside)
	button.add_child.call_deferred(background_bottomside)
	button.add_child.call_deferred(background_leftside)
	
func _on_mouse_hovered(hovered: bool) -> void:
	reset_tween()
	recalculate_outline_size(background_topside, background_rightside, background_bottomside, background_leftside)
	tween.tween_property(background_topside, "color", outline_color if hovered else Color(0.0, 0.0, 0.0, 0.0), animation_duration)
	tween.tween_property(background_rightside, "color", outline_color if hovered else Color(0.0, 0.0, 0.0, 0.0), animation_duration)
	tween.tween_property(background_bottomside, "color", outline_color if hovered else Color(0.0, 0.0, 0.0, 0.0), animation_duration)
	tween.tween_property(background_leftside, "color", outline_color if hovered else Color(0.0, 0.0, 0.0, 0.0), animation_duration)
	
func recalculate_outline_size(topside, rightside, bottomside, leftside) -> void:
	topside.position = Vector2(-1, -1)
	rightside.position = Vector2(button.size.x, -1)
	bottomside.position = Vector2(-1, button.size.y)
	leftside.position = Vector2(-1, -1)
	
	topside.size = Vector2(button.size.x + 2, 1)
	rightside.size = Vector2(1, button.size.y + 2)
	bottomside.size = Vector2(button.size.x + 2, 1)
	leftside.size = Vector2(1, button.size.y + 2)

func reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween().set_ease(ease_type).set_trans(transition_type).set_parallel(true)

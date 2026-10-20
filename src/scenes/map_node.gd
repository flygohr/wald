extends Node2D

@export var color : Color
@export var scale_mult := 0.06

@onready var node_sprite: Sprite2D = $NodeSprite

func _ready() -> void:
	update_texture(color, scale_mult)

func update_texture(c: Color, s: float) -> void:
	node_sprite.modulate = c
	node_sprite.scale = scale * s

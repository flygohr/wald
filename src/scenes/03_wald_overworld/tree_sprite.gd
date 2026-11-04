extends Sprite2D
class_name TreeSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_tree(0, 0.5, 0.25, 0.35, false)

func set_tree(f: int, s: float, min_s: float, max_s: float, t: bool) -> void:
	if f < hframes*vframes:
		set_frame(f)

	if s >= 0 and s <= 1:
		var new_scale = remap(s, 0.0, 1.0, min_s, max_s)
		scale = Vector2(new_scale, new_scale)
	
	flip_h = t

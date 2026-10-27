extends PanelContainer

@onready var node_type_name_label: Label = $VBoxContainer/HBoxContainer/NodeTypeNameLabel
@onready var travel_button: Button = $VBoxContainer/MarginContainer/TravelButton

var target_node_index: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = 0
	SignalBus.node_selected.connect(node_selected)
	SignalBus.moved_around_the_map.connect(_fade_out_this)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func node_selected(i: int) -> void:
	var node_data: Dictionary = GameData.current[GameData.KEY_MAP_NODES_DATA][i]
	if GameData.current[GameData.KEY_MAP_CURRENT_NODE_INDEX] != i:
		target_node_index = i
		_fade_in_this()
	else:
		_fade_out_this()
	


func _fade_in_this() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.3).set_trans(Tween.TRANS_SINE)

func _fade_out_this() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.3).set_trans(Tween.TRANS_SINE)


func _on_travel_button_pressed() -> void:
	SignalBus.traveled_to.emit(target_node_index)
	_fade_out_this()

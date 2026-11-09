extends PanelContainer

@export var cost_box_scene: PackedScene

@onready var node_type_name_label: Label = $VBoxContainer/HBoxContainer/NodeTypeNameLabel
@onready var cost_container: HBoxContainer = $VBoxContainer/MarginContainer/CostContainer
@onready var action_button: Button = $VBoxContainer/ActionButton

var target_node_index: int
var cost_references: Array = []

#TODO: convert in all purposes prompt with costs, title, icon, etc

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = 0
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	SignalBus.node_selected.connect(node_selected)
	SignalBus.moved_around_the_map.connect(_fade_out_this)


func node_selected(i: int) -> void:
	var node_data: Dictionary = GameData.current[GameData.KEY_MAP_NODES_DATA][i]
	node_type_name_label.text = node_data[GameData.KEY_MAPNODETYPE].to_upper()
	if GameData.current[GameData.KEY_MAP_NODES_DATA][GameData.current[GameData.KEY_MAP_CURRENT_NODE_INDEX]][GameData.KEY_IS_CLEARED] == false and GameData.current[GameData.KEY_MAP_NODES_DATA][GameData.current[GameData.KEY_MAP_CURRENT_NODE_INDEX]][GameData.KEY_INCOMING_CONNECTIONS].has(i) == false:
		action_button.disabled = true
	else: action_button.disabled = false
	
	# Clear cost boxes
	for cost_box in cost_references:
		cost_box.queue_free()
		
	cost_references = []
	
	for cost in range(2):
		var cost_box: CostBox = cost_box_scene.instantiate()
		cost_container.add_child(cost_box)
		cost_box.cost_label.text = "-2"
		cost_references.append(cost_box)
	
	if GameData.current[GameData.KEY_MAP_CURRENT_NODE_INDEX] != i:
		target_node_index = i
		_fade_in_this()
	else:
		_fade_out_this()
	


func _fade_in_this() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.3).set_trans(Tween.TRANS_SINE)


func _fade_out_this() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.3).set_trans(Tween.TRANS_SINE)


func _on_travel_button_pressed() -> void:
	SignalBus.traveled_to.emit(GameData.current[GameData.KEY_MAP_CURRENT_NODE_INDEX], target_node_index)
	_fade_out_this()

func populate_action_prompt() -> void:
	# Get icon
	# Get name
	# Get costs
	# Get action button text
	# Connect result
	pass

extends PanelContainer
class_name ActionPrompt

@export var cost_box_scene: PackedScene

@onready var prompt_icon: TextureRect = $VBoxContainer/HBoxContainer/PromptIcon

@onready var prompt_name: Label = $VBoxContainer/HBoxContainer/PromptName
@onready var cost_container: HBoxContainer = $VBoxContainer/MarginContainer/CostContainer
@onready var prompt_button: Button = $VBoxContainer/PromptButton

var target_node_index: int
var cost_references: Array = []

var results_to_execute: Array = []
var costs_to_evaluate: Array = []

#TODO: convert in all purposes prompt with costs, title, icon, etc

#TODO: connect signal to build and display new prompt in the UI! but this needs to go in the UI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = 0
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	SignalBus.moved_around_the_map.connect(_fade_out_this)
	SignalBus.fade_out_prompt.connect(_fade_out_this)


func populate(
	prompt_name_str: String, 
	prompt_icon_res: Texture2D, 
	prompt_costs_array: Array, 
	prompt_btn_text: String, 
	prompt_result_array: Array
	) -> void:
		prompt_name.text = prompt_name_str
		
		prompt_icon.texture = prompt_icon_res
		
		costs_to_evaluate = prompt_costs_array
		for cost in prompt_costs_array:
			var cost_box: CostBox = cost_box_scene.instantiate()
			
			cost_container.add_child(cost_box)
			cost_box.populate(cost)
		
		prompt_button.text = prompt_btn_text
		
		results_to_execute = prompt_result_array
		
		_fade_in_this()
	

func _fade_in_this() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.3).set_trans(Tween.TRANS_SINE)


func _fade_out_this(prompt_name: String = self.name) -> void:
	if prompt_name == self.name:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.3).set_trans(Tween.TRANS_SINE)
		queue_free()


func _on_prompt_button_pressed() -> void:
	WaldProcessor.process_prompt(costs_to_evaluate, results_to_execute, self.name)

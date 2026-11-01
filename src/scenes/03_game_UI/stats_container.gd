extends PanelContainer

@onready var sanity_label: Label = $HBoxContainer/HBoxContainer/MarginContainer/SanityLabel
@onready var food_label: Label = $HBoxContainer/HBoxContainer2/MarginContainer/FoodLabel
@onready var karma_label: Label = $HBoxContainer/HBoxContainer3/MarginContainer/KarmaLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.sanity_updated.connect(update_sanity)
	SignalBus.food_updated.connect(update_food)
	SignalBus.karma_updated.connect(update_karma)
	
	
func update_sanity(value: int) -> void:
	pass


func update_food(value: int) -> void:
	pass


func update_karma(value: int) -> void:
	pass

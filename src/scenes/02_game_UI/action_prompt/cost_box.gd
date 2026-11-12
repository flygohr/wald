extends PanelContainer
class_name CostBox

@onready var cost_icon: TextureRect = $HBoxContainer/CostIcon
@onready var cost_label: Label = $HBoxContainer/CostLabel

func populate(data: Dictionary) -> void:
	cost_icon.texture = data[ActionsData.KEY_COST_ICON]
	cost_label.text = str("-", data[ActionsData.KEY_COST_VALUE])
	

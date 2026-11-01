extends CanvasLayer

#TODO: tweak UI depending on current scene, if wald or local
@onready var overworld_button: TextureButton = $MarginContainer/VBoxContainer/Bottom/LeftButtonsContainer/OverworldButton
@onready var go_inside_node_button: TextureButton = $MarginContainer/VBoxContainer/Bottom/LeftButtonsContainer/GoInsideNodeButton
@onready var party_button: TextureButton = $MarginContainer/VBoxContainer/Bottom/LeftButtonsContainer/PartyButton

@onready var basic_actions: PanelContainer = $MarginContainer/VBoxContainer/Bottom/ActionButtonsContainer/BasicActions

@export var action_prompt_scene: PackedScene
@onready var action_buttons_container: VBoxContainer = $MarginContainer/VBoxContainer/Bottom/ActionButtonsContainer

@onready var debug_buttons: Control = $DebugButtons

func _ready() -> void:
	var action_prompt = action_prompt_scene.instantiate()
	action_buttons_container.add_child(action_prompt)
	action_buttons_container.move_child(action_prompt, 0)
	
	
	if GameData.is_inside_node == true:
		overworld_button.show()
		basic_actions.show()
		debug_buttons.show()
		go_inside_node_button.hide()
	elif GameData.is_inside_node == false:
		overworld_button.hide()
		basic_actions.hide()
		debug_buttons.hide()
		go_inside_node_button.show()

func _on_quit_button_pressed() -> void:
	ScenesManager.load_scene(ScenesManager.SCENE_PATHS[ScenesManager.KEY_TITLE_SCREEN])


func _on_menu_button_pressed() -> void:
	Settings.transition_in()


func _on_overworld_button_pressed() -> void:
	GameData.is_inside_node = false
	GameData.initiate_save_game_data()
	ScenesManager.load_scene(ScenesManager.SCENE_PATHS[ScenesManager.KEY_OVERWORLD_SCREEN])


func _on_go_inside_node_button_pressed() -> void:
	GameData.is_inside_node = true
	GameData.initiate_save_game_data()
	ScenesManager.load_scene(ScenesManager.SCENE_PATHS[ScenesManager.KEY_INSIDE_NODE_SCREEN])

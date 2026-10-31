extends CanvasLayer

#TODO: tweak UI depending on current scene, if wald or local
@onready var overworld_button: TextureButton = $MarginContainer/VBoxContainer/Bottom/VBoxContainer/OverworldButton
@onready var go_inside_node_button: TextureButton = $MarginContainer/VBoxContainer/Bottom/VBoxContainer/GoInsideNodeButton
@onready var party_button: TextureButton = $MarginContainer/VBoxContainer/Bottom/VBoxContainer/PartyButton
@onready var resources_button: TextureButton = $MarginContainer/VBoxContainer/Bottom/VBoxContainer/ResourcesButton

func _ready() -> void:
	if GameData.is_inside_node == true:
		overworld_button.show()
		go_inside_node_button.hide()
	else:
		overworld_button.hide()
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

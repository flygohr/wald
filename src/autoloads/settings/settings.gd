extends Node2D

const TITLE_SCREEN_SCENE: StringName = ScenesManager.SCENE_PATHS[ScenesManager.KEY_TITLE_SCREEN]

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var music_slider: HSlider = $CanvasLayer/MarginContainer/VBoxContainer/MusicSliderContainer/MusicSlider
@onready var music_slider_value: Label = $CanvasLayer/MarginContainer/VBoxContainer/MusicSliderContainer/MusicSliderValue
@onready var sfx_slider: HSlider = $CanvasLayer/MarginContainer/VBoxContainer/SFXSliderContainer/SFXSlider
@onready var sfx_slider_value: Label = $CanvasLayer/MarginContainer/VBoxContainer/SFXSliderContainer/SFXSliderValue

@onready var quit_button: Button = $CanvasLayer/MarginContainer/VBoxContainer/QuitButton

func _ready() -> void:	
	# Settings menu to look different depending on if in game or not
	transition_back()
	SavesManager.load_config(GameData.config)
	SignalBus.pause_game.connect(transition_in)
	SignalBus.resume_game.connect(transition_back)
	music_slider.value = GameData.config[GameData.KEY_MUSIC_VOLUME]
	music_slider_value.text = str(GameData.config[GameData.KEY_MUSIC_VOLUME], "%")
	sfx_slider.value = GameData.config[GameData.KEY_SFX_VOLUME]
	sfx_slider_value.text = str(GameData.config[GameData.KEY_SFX_VOLUME], "%")

func _on_back_button_pressed() -> void:
	transition_back()

func _on_export_save_button_pressed() -> void:
	SavesManager.export_save(GameData.current, GameData.GAME_NAME, GameData.GAME_VERSION, GameData.active_save_slot)

func _on_import_save_button_pressed() -> void:
	SavesManager.import_save(GameData.current, GameData.active_save_slot)

func _on_quit_button_pressed() -> void:
	ScenesManager.load_scene(TITLE_SCREEN_SCENE)

func _on_music_slider_value_changed(value: float) -> void:
	GameData.config[GameData.KEY_MUSIC_VOLUME] = int(value)
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"),value/100)
	SavesManager.save_config(GameData.config)
	music_slider_value.text = (str(int(value),"%"))

func _on_sfx_slider_value_changed(value: float) -> void:
	GameData.config[GameData.KEY_SFX_VOLUME] = int(value)
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"),value/100)
	SavesManager.save_config(GameData.config)
	sfx_slider_value.text = (str(int(value),"%"))

func transition_back() -> void:
	canvas_layer.visible = false
	get_tree().paused = false

func transition_in() -> void:
	get_tree().paused = true
	SavesManager.load_config(GameData.config)
	canvas_layer.visible = true

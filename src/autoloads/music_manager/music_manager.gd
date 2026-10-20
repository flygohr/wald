# Contains signals to switch between various background soundtracks
# Struggled to understand how to have this as a persistent node with the ScenesManager's change_scene_to_packed thing
# Solution found: https://www.reddit.com/r/godot/comments/1kww9uj/changing_scene_while_keeping_a_main_node/
# Didn't know you could autoload entire scenes

extends Node

@onready var music_player: AudioStreamPlayer2D = $MusicPlayer
@onready var sfx_player: AudioStreamPlayer2D = $SFXPlayer

func _ready() -> void:
	music_player.play()
	sfx_player.play()

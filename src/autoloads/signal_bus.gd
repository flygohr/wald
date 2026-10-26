# Script to handle all the signals in the game

extends Node

@warning_ignore_start("unused_signal")

signal pause_game
signal resume_game

signal pan_to(end: Vector2)

signal debug_travel(index: int)
signal new_active_node_set(index: int)

@warning_ignore_restore("unused_signal")

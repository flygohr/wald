# Script to handle all the signals in the game

extends Node

@warning_ignore_start("unused_signal")

signal pause_game
signal resume_game

signal finished_generating_map(nodes_list: Array)
signal generated_map_limits(x: int, y: int, w: int, h: int)

signal debug_travel(coords: Vector2)

@warning_ignore_restore("unused_signal")

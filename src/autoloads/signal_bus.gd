# Script to handle all the signals in the game

extends Node

@warning_ignore_start("unused_signal")

signal pause_game
signal resume_game


signal generate_new_map()
signal finished_generating_map(nodes_list: Array)
signal map_boundaries_set(left_x: int, top_y: int, right_x: int, bottom_y: int)

signal debug_travel(coords: Vector2)

@warning_ignore_restore("unused_signal")

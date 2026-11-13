# Script to handle all the signals in the game

extends Node

@warning_ignore_start("unused_signal")

signal pause_game
signal resume_game

signal pan_to(end: Vector2)

signal pause_map(toggle: bool)

signal node_selected(index: int)
signal traveled_to(from: int, to: int)
signal moved_around_the_map
signal new_active_node_set(index: int)
signal walking_distance_updated

# STATS SIGNALS ----------------------------------------------------------------
signal sanity_updated(value: int)
signal food_updated(value: int)
signal karma_updated(value: int)
signal loot_updated(value: int)
signal days_updated(value: int)
signal node_status_updated(index: int, toggle: bool)
signal walk_distance_updated(value: int)

# ACTIONS ----------------------------------------------------------------------
signal action_prompt_created(prompt_data: Dictionary)

@warning_ignore_restore("unused_signal")

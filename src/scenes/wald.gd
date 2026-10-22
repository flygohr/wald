extends Node2D

var nodes_list: Array

func _ready() -> void:
	SignalBus.finished_generating_map.connect(finished_generating_map)
	
func finished_generating_map(list: Array) -> void:
	nodes_list = list
	

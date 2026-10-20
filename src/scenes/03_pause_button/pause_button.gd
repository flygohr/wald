extends Button

func _on_pressed() -> void:
	SignalBus.pause_game.emit()

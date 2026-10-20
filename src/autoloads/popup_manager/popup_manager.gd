extends Node2D

@onready var popup: CanvasLayer = $Popup
@onready var background_panel: Panel = $Popup/BackgroundPanel
@onready var popup_container: MarginContainer = $Popup/PopupContainer
@onready var popup_text_container: PanelContainer = $Popup/PopupContainer/VBoxContainer/PopupTextContainer
@onready var popup_text_label: RichTextLabel = $Popup/PopupContainer/VBoxContainer/PopupTextContainer/MarginContainer/PopupTextLabel
@onready var buttons_container: HBoxContainer = $Popup/PopupContainer/VBoxContainer/ButtonsContainer
@onready var no_button: Button = $Popup/PopupContainer/VBoxContainer/ButtonsContainer/NoButton
@onready var yes_button: Button = $Popup/PopupContainer/VBoxContainer/ButtonsContainer/YesButton
@onready var next_button: Button = $Popup/PopupContainer/VBoxContainer/ButtonsContainer/NextButton

signal no_button_pressed
signal yes_button_pressed
signal next_button_pressed

#TODO: work on a fade in and fade out of popups

func show_popup_confirmation(popup_text: String, no_button_text: String = "No", yes_button_text: String = "Yes") -> void:
	no_button.show()
	yes_button.show()
	next_button.hide()
	
	popup.show()
	popup_text_label.text = popup_text
	no_button.text = no_button_text
	yes_button.text = yes_button_text

func show_popup_dialog(popup_text: String, next_button_text: String = "Next") -> void:
	no_button.hide()
	yes_button.hide()
	next_button.show()
	
	popup.show()
	popup_text_label.text = popup_text
	next_button.text = next_button_text

func _on_no_button_pressed() -> void:
	popup.hide()
	no_button_pressed.emit()

func _on_yes_button_pressed() -> void:
	popup.hide()
	yes_button_pressed.emit()

func _on_next_button_pressed() -> void:
	popup.hide()
	next_button_pressed.emit()

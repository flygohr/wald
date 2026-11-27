extends Node2D

@onready var rat_button: Button = $CharactersUI/MarginContainer/HBoxContainer/VBoxContainer/VBoxContainer/RatButton
@onready var squirrel_button: Button = $CharactersUI/MarginContainer/HBoxContainer/VBoxContainer/VBoxContainer/SquirrelButton
@onready var raven_button: Button = $CharactersUI/MarginContainer/HBoxContainer/VBoxContainer/VBoxContainer/RavenButton
@onready var rabbit_button: Button = $CharactersUI/MarginContainer/HBoxContainer/VBoxContainer/VBoxContainer/RabbitButton
@onready var fox_button: Button = $CharactersUI/MarginContainer/HBoxContainer/VBoxContainer/VBoxContainer/FoxButton

@onready var character_name_label: Label = $CharactersUI/MarginContainer/HBoxContainer/CharacterContainer/VBoxContainer/CharacterNameLabel
@onready var character_texture_rect: TextureRect = $CharactersUI/MarginContainer/HBoxContainer/CharacterContainer/VBoxContainer/CharacterTextureRect
@onready var character_text_label: Label = $CharactersUI/MarginContainer/HBoxContainer/CharacterContainer/VBoxContainer/Panel/MarginContainer/CharacterTextLabel

@onready var betray_rabbit: Button = $CharactersUI/MarginContainer/HBoxContainer/VBoxContainer/BetrayAction/BetrayRabbit


var rat_name: String = "RAT THIEF, AKA ME"
var rat_image: Texture2D = preload("uid://dmj8ikook07qo")
var rat_text: String = "It's not much, but it's enough to have survived until now. I have all I need to make it out there, but it won't be easy if I do it alone.\nI don't have a way to traverse chasms and rapids, nor to travel long distances."

var squirrel_recruited_name: String = "THE SQUIRREL BARD"
var squirrel_undiscovered_name: String = "A SQUIRREL"
var squirrel_image: Texture2D = preload("uid://dmj8ikook07qo")
var squirrel_undiscovered_text: String = ""
var squirrel_recruited_text: String = ""

var raven_recruited_name: String = "THE RAVEN RANGER"
var raven_undiscovered_name: String = "A RAVEN"
var raven_image: Texture2D = preload("uid://dmj8ikook07qo")
var raven_undiscovered_text: String = ""
var raven_recruited_text: String = ""

var rabbit_recruited_name: String = "THE RABBIT STRAY"
var rabbit_undiscovered_name: String = "A RABBIT"
var rabbit_image: Texture2D = preload("uid://dmj8ikook07qo")
var rabbit_undiscovered_text: String = ""
var rabbit_recruited_text: String = ""

var fox_recruited_name: String = "THE FOX ROGUE"
var fox_undiscovered_name: String = "A FOX"
var fox_image: Texture2D = preload("uid://dmj8ikook07qo")
var fox_undiscovered_text: String = ""
var fox_recruited_text: String = ""

func _ready() -> void:
	rat_button.button_pressed = true
	squirrel_button.text = squirrel_undiscovered_name
	raven_button.text = raven_undiscovered_name
	rabbit_button.text = rabbit_undiscovered_name
	fox_button.text = fox_undiscovered_name
	
	if GameData.current[GameData.KEY_SQUIRREL_IN_PARTY]:
		squirrel_button.text = squirrel_recruited_name
		
	if GameData.current[GameData.KEY_RAVEN_IN_PARTY]:
		raven_button.text = raven_recruited_name
	
	if GameData.current[GameData.KEY_RABBIT_IN_PARTY]:
		rabbit_button.text = rabbit_recruited_name
	
	if GameData.current[GameData.KEY_FOX_IN_PARTY]:
		fox_button.text = fox_recruited_name
		

func _on_rat_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		squirrel_button.button_pressed = false
		raven_button.button_pressed = false
		rabbit_button.button_pressed = false
		fox_button.button_pressed = false
		character_name_label.text = rat_name
		character_texture_rect.texture = rat_image
		character_text_label.text = rat_text
		character_texture_rect.modulate = Color(1.0, 1.0, 1.0, 1.0)


func _on_squirrel_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		rat_button.button_pressed = false
		raven_button.button_pressed = false
		rabbit_button.button_pressed = false
		fox_button.button_pressed = false
		character_texture_rect.texture = squirrel_image
		if GameData.current[GameData.KEY_SQUIRREL_IN_PARTY]:
			character_name_label.text = squirrel_recruited_name
			character_text_label.text = squirrel_recruited_text
			character_texture_rect.modulate = Color(1.0, 1.0, 1.0, 1.0)
		else:
			character_name_label.text = squirrel_undiscovered_name
			character_text_label.text = squirrel_undiscovered_text
			character_texture_rect.modulate = Color(0, 0, 0, 1)


func _on_raven_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		rat_button.button_pressed = false
		squirrel_button.button_pressed = false
		rabbit_button.button_pressed = false
		fox_button.button_pressed = false
		character_texture_rect.texture = raven_image
		if GameData.current[GameData.KEY_RAVEN_IN_PARTY]:
			character_name_label.text = raven_recruited_name
			character_text_label.text = raven_recruited_text
			character_texture_rect.modulate = Color(1.0, 1.0, 1.0, 1.0)
		else:
			character_name_label.text = raven_undiscovered_name
			character_text_label.text = raven_undiscovered_text
			character_texture_rect.modulate = Color(0, 0, 0, 1)


func _on_rabbit_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		rat_button.button_pressed = false
		squirrel_button.button_pressed = false
		raven_button.button_pressed = false
		fox_button.button_pressed = false
		character_texture_rect.texture = rabbit_image
		if GameData.current[GameData.KEY_RABBIT_IN_PARTY]:
			character_name_label.text = rabbit_recruited_name
			character_text_label.text = rabbit_recruited_text
			character_texture_rect.modulate = Color(1.0, 1.0, 1.0, 1.0)
			betray_rabbit.show()
		else:
			character_name_label.text = rabbit_undiscovered_name
			character_text_label.text = rabbit_undiscovered_text
			character_texture_rect.modulate = Color(0, 0, 0, 1)
			betray_rabbit.hide()
			


func _on_fox_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		rat_button.button_pressed = false
		squirrel_button.button_pressed = false
		raven_button.button_pressed = false
		rabbit_button.button_pressed = false
		character_texture_rect.texture = fox_image
		if GameData.current[GameData.KEY_FOX_IN_PARTY]:
			character_name_label.text = fox_recruited_name
			character_text_label.text = fox_recruited_text
			character_texture_rect.modulate = Color(1.0, 1.0, 1.0, 1.0)
		else: 
			character_name_label.text = fox_undiscovered_name
			character_text_label.text = fox_undiscovered_text
			character_texture_rect.modulate = Color(0, 0, 0, 1)


func _on_betray_rabbit_pressed() -> void:
	pass
	# TODO: invoke rabbit prompt here

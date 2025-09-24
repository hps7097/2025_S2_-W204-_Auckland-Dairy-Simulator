# MADE WITH CHATGPT
extends Control

@onready var play_button = $VBox/PlayButton
@onready var options_button = $VBox/OptionsButton
@onready var load_button = $VBox/LoadButton
@onready var quit_button = $VBox/QuitButton

func _ready():
	pass

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/dayScreen.tscn")
	GameManager.newDay()

func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://scenes/OptionsMenu.tscn")

func _on_load_button_pressed():
	get_tree().change_scene_to_file("res://scenes/LoadMenu.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

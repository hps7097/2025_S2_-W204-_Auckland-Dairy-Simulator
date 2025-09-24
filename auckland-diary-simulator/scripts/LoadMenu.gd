# MADE WITH CHATGPT
extends Control

@onready var load_button = $VBox/LoadButton
@onready var back_button = $VBox/BackButton

func _ready():
	load_button.connect("pressed", Callable(self, "_on_load_pressed"))
	back_button.connect("pressed", Callable(self, "_on_back_pressed"))

func _on_load_pressed():
	if SaveSystem.load_game():
		get_tree().change_scene_to_file("res://scenes/dayScreen.tscn")
	else:
		print("No save found!")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/UI/MainMenu.tscn")

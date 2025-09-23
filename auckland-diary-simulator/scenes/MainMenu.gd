# MADE WITH CHATGPT
extends Control

@onready var play_button = $VBox/PlayButton
@onready var options_button = $VBox/OptionsButton
@onready var load_button = $VBox/LoadButton
@onready var quit_button = $VBox/QuitButton

func _ready():
	play_button.connect("pressed", Callable(self, "_on_play_pressed"))
	options_button.connect("pressed", Callable(self, "_on_options_pressed"))
	load_button.connect("pressed", Callable(self, "_on_load_pressed"))
	quit_button.connect("pressed", Callable(self, "_on_quit_pressed"))

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/dayScreen.tscn")

func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/OptionsMenu.tscn")

func _on_load_pressed():
	get_tree().change_scene_to_file("res://scenes/LoadMenu.tscn")

func _on_quit_pressed():
	get_tree().quit()

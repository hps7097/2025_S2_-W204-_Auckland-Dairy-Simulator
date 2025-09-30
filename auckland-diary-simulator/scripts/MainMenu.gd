# MADE WITH CHATGPT
extends Control

@onready var play_button = $VBox/PlayButton
@onready var options_button = $VBox/OptionsButton
@onready var load_button = $VBox/LoadButton
@onready var quit_button = $VBox/QuitButton

const OPTIONS_MENU = preload("res://scenes/OptionsMenu.tscn")
var optionsMenu

func _ready():
	pass

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/dayScreen.tscn")
	GameManager.newDay()

func _on_options_button_pressed():
	optionsMenu = OPTIONS_MENU.instantiate()
	optionsMenu.z_index = 4096 
	get_tree().current_scene.add_child(optionsMenu)

func _on_load_button_pressed():
	if SaveManager.load_game():
		money = SaveManager.save_data["money"]
		dayCount = SaveManager.save_data["day"]
		inventory = SaveManager.save_data["inventory"]

func _on_quit_button_pressed():
	get_tree().quit()

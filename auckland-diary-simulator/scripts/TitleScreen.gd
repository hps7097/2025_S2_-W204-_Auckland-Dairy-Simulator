#MADE WITH CHATGPT
extends Control

@onready var btn_continue := $BtnContinue 
@onready var btn_new := $BtnNewGame 
@onready var btn_options := $BtnOptions 

func _ready(): 
	btn_continue.pressed.connect(_on_continue)
	btn_new.pressed.connect(_on_newgame)
	btn_options.pressed.connect(_on_options)
	_update_continue_state()

func _update_continue_state(): 
	var data = SaveManager.load_game() 
	btn_continue.disabled = data.empty() 

func _on_continue(): 
	var data = SaveManager.load_game() 
	if data.empty():
		_start_new_game() 
		return 
	if "scene" in data:
		get_tree().change_scene_to_file(data["scene"]) 
	else: 
		_start_new_game() 

func _on_newgame(): 
	_start_new_game() 

func _on_options(): 
	var opts_scene = preload("res://scenes/options_menu.tscn").instantiate()
	get_tree().get_root().add_child(opts_scene)

func _start_new_game(): 
	SaveManager.save_game({
		"scene": "res://scenes/day/DayScene.tscn",
		"day": 1
	}) 
	get_tree().change_scene_to_file("res://scenes/day/DayScene.tscn")

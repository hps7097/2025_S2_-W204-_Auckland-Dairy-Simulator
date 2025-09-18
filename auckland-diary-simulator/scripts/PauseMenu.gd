#MADE WITH CHATGPT
extends Control

@onready var btn_resume := $BtnResume 
@onready var btn_options := $BtnOptions 
@onready var btn_save := $BtnSave 
@onready var btn_load := $BtnLoad 
@onready var saved_label := $SavedLabel

func _ready(): 
	btn_resume.pressed.connect(_on_resume)
	btn_options.pressed.connect(_on_options)
	btn_save.pressed.connect(_on_save)
	btn_load.pressed.connect(_on_load)

func _on_resume(): 
	get_tree().paused = false 
	queue_free() 

func _on_options(): 
	var opts = preload("res://scenes/options_menu.tscn").instantiate()
	get_tree().get_root().add_child(opts)

func _on_save(): 
	# Dummy save data since GameState is undefined
	var data = {
		"scene": get_tree().current_scene.scene_file_path
	}
	SaveManager.save_game(data)

	saved_label.show()
	var timer := get_tree().create_timer(1.2)
	await timer.timeout
	saved_label.hide()

func _on_load(): 
	var data = SaveManager.load_game()
	if data.empty():
		return

	# Skip GameState.import_state since it's undefined

	if "scene" in data:
		get_tree().change_scene_to_file(data["scene"])

# MADE WITH CHATGPT
extends CanvasLayer

@onready var resume_button: Button = $Panel/VBox/ResumeButton
@onready var options_button: Button = $Panel/VBox/OptionsButton
@onready var save_button: Button = $Panel/VBox/SaveButton
@onready var load_button: Button = $Panel/VBox/LoadButton
@onready var quit_button: Button = $Panel/VBox/QuitButton
@onready var music: AudioStreamPlayer = get_tree().root.get_node("Main/MusicPlayer") # adjust path

func _ready() -> void:
	resume_button.pressed.connect(_on_resume_pressed)
	options_button.pressed.connect(_on_options_pressed)
	save_button.pressed.connect(_on_save_pressed)
	load_button.pressed.connect(_on_load_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func toggle() -> void:
	visible = not visible
	get_tree().paused = visible

	# Handle music pause/resume
	if music:
		music.stream_paused = visible

func _on_resume_pressed() -> void:
	toggle()

func _on_options_pressed() -> void:
	if get_tree().root.has_node("Main/OptionsMenu"):
		get_tree().root.get_node("Main/OptionsMenu").show()
	else:
		get_tree().change_scene_to_file("res://scenes/UI/OptionsMenu.tscn")

func _on_LoadGame_pressed():
    get_tree().change_scene("res://scenes/LoadMenu.tscn")

func _on_SaveGame_pressed():
    GameState.save_to_file("manual_save")

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/UI/MainMenu.tscn")

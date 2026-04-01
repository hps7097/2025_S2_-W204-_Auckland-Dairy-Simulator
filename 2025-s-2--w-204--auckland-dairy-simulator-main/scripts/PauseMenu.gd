#MADE WITH CHATGPT
# PauseMenu.gd
extends Control

@onready var btn_resume: Button = $BtnResume
@onready var btn_save: Button = $BtnSave
@onready var btn_options: Button = $BtnOptions
@onready var btn_quit: Button = $BtnQuit
@onready var btn_title: Button = $BtnTitle   
@onready var options_popup: Control = $OptionsMenu


func _ready() -> void:
	visible = false
	btn_resume.pressed.connect(Callable(self, "_on_resume_pressed"))
	btn_save.pressed.connect(Callable(self, "_on_save_pressed"))
	btn_options.pressed.connect(Callable(self, "_on_options_pressed"))
	btn_quit.pressed.connect(Callable(self, "_on_quit_pressed"))
	btn_title.pressed.connect(Callable(self, "_on_title_pressed")) 

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause() -> void:
	visible = not visible
	get_tree().paused = visible

func _on_resume_pressed() -> void:
	toggle_pause()

func _on_save_pressed() -> void:
	SaveManager.save_game(GameState.to_dict())

func _on_options_pressed() -> void:
	options_popup.show()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_title_pressed() -> void:
	get_tree().paused = false   
	get_tree().change_scene_to_file("res://scenes/TitleScreen.tscn")

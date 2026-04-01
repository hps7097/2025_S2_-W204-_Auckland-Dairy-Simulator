#MADE WITH CHATGPT
extends Control

@onready var btn_start: Button = $BtnStart
@onready var btn_load: Button = $BtnLoad
@onready var btn_options: Button = $BtnOptions
@onready var btn_quit: Button = $BtnQuit
@onready var options_popup: Control = $OptionsMenu

func _ready() -> void:
	btn_start.pressed.connect(Callable(self, "_on_start_pressed"))
	btn_load.pressed.connect(Callable(self, "_on_load_pressed"))
	btn_options.pressed.connect(Callable(self, "_on_options_pressed"))
	btn_quit.pressed.connect(Callable(self, "_on_quit_pressed"))


func _on_start_pressed() -> void:
	# Start a fresh game (reset GameState)
	GameState.money = 0
	GameState.police_rep = 0
	GameState.gang_rep = 0
	GameState.flags = {}
	GameState.day = 1
	GameState.save()
	get_tree().change_scene_to_file("res://scenes/dayScreen.tscn")

func _on_load_pressed() -> void:
	var data := SaveManager.load_game()
	if data.size() > 0:
		# Load values back into GameState
		GameState.money = data.get("money", 0)
		GameState.police_rep = data.get("police_rep", 0)
		GameState.gang_rep = data.get("gang_rep", 0)
		GameState.flags = data.get("flags", {})
		GameState.day = data.get("day", 1)
		get_tree().change_scene_to_file("res://scenes/dayScreen.tscn")
	else:
		print("⚠️ No save file found")

func _on_options_pressed() -> void:
	options_popup.show()

func _on_quit_pressed() -> void:
	get_tree().quit()

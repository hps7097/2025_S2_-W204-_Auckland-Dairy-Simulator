# MADE WITH CHATGPT
extends Control

const OPTIONS_MENU = preload("res://scenes/OptionsMenu.tscn")
var optionsMenu

@onready var popup_text: Node2D = $PopupText

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass


# --- BUTTON CALLBACKS ---

func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")


func _on_save_button_pressed() -> void:
	# Example: fetch data from GameState or your main scene
	var game_state = {
		"money": GameManager.getMoneyStart(),
		"day": GameManager.getDayCount(),
		"dayNight": GameManager.getDayNight(),
		"upgrades": UpgradeManager.upgrades,
		"flags": GameManager.getFlags()
	}
	
	var success = SaveManager.save_game("1", game_state)
	if success:
		print("Game saved successfully ✅")
		popup_text.calling("Game saved successfully")
	else:
		printerr("Failed to save game ❌")
		popup_text.calling("Failed to save game")

func _on_options_button_pressed() -> void:
	optionsMenu = OPTIONS_MENU.instantiate()
	optionsMenu.z_index = 4096 
	get_tree().current_scene.add_child(optionsMenu)


func _on_resume_button_pressed() -> void:
	queue_free()

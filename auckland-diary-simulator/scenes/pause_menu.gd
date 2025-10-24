# FIXED BY CHATGPT (based on old PauseMenu.gd)
extends Control

const OPTIONS_MENU = preload("res://scenes/OptionsMenu.tscn")
var optionsMenu: Control

# --- BUTTON CALLBACKS ---

func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func _on_save_button_pressed() -> void:
	var success = GameState.save_to_file("autosave")  # ✅ simplified
	if success:
		print("Game saved successfully ✅")
	else:
		printerr("Failed to save game ❌")

func _on_load_button_pressed() -> void:
	var success = GameState.load_from_file("autosave")  # ✅ simplified
	if success:
		print("Game loaded successfully ✅")
	else:
		printerr("Failed to load game ❌")

func _on_options_button_pressed() -> void:
	optionsMenu = OPTIONS_MENU.instantiate()
	optionsMenu.z_index = 4096 
	get_tree().current_scene.add_child(optionsMenu)

func _on_resume_button_pressed() -> void:
	queue_free()


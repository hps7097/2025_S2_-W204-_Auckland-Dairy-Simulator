# MADE WITH CHATGPT
extends Control

const OPTIONS_MENU = preload("res://scenes/OptionsMenu.tscn")
var optionsMenu

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
		"money": ProductManager.money,
		"day": GameManager.getDayCount(),
	}
	
	var success = SaveManager.save_game("1", game_state)
	if success:
		print("Game saved successfully ✅")
	else:
		printerr("Failed to save game ❌")

# Disabled because doesnt work and only want loading on main menu
func _on_load_button_pressed() -> void:
	var loaded_data = SaveManager.load_game("1")
	if loaded_data:
		ProductManager.money = loaded_data.get("money", 0)
		GameManager.day_count = loaded_data.get("day", 1)
		print("Game loaded successfully ✅")
	else:
		printerr("Failed to load game ❌")


func _on_options_button_pressed() -> void:
	optionsMenu = OPTIONS_MENU.instantiate()
	optionsMenu.z_index = 4096 
	get_tree().current_scene.add_child(optionsMenu)


func _on_resume_button_pressed() -> void:
	queue_free()

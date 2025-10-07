#MADE WITH CHATGPT

extends Control

const OPTIONS_MENU = preload("res://scenes/OptionsMenu.tscn")
var optionsMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func _on_save_button_pressed():
	SaveManager.save_data["money"] = money
	SaveManager.save_data["day"] = dayCount
	SaveManager.save_data["inventory"] = inventory
	SaveManager.save_game()

func _on_load_button_pressed():
	if SaveManager.load_game():
		money = SaveManager.save_data["money"]
		dayCount = SaveManager.save_data["day"]
		inventory = SaveManager.save_data["inventory"]

func _on_options_button_pressed() -> void:
	optionsMenu = OPTIONS_MENU.instantiate()
	optionsMenu.z_index = 4096 
	get_tree().current_scene.add_child(optionsMenu)

func _on_resume_button_pressed() -> void:
	queue_free()

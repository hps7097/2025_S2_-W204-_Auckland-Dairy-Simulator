#MADE WITH CHATGPT
extends Control
@onready var ending_text = $ending_text

func set_text(txt: String):
	ending_text.text = txt

func _on_return_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

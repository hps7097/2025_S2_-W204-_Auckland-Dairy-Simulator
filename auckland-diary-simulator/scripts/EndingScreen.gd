#MADE WITH CHATGPT
extends Control
@onready var day_7: TextureRect = $Day7
@onready var top: Sprite2D = $Top
@onready var bottom: Sprite2D = $Bottom
@onready var ending_title: TextureRect = $EndingTitle
@onready var return_to_main_menu: Button = $"Return to Main Menu"

func _ready() -> void:
	
	# HAVE CHECK THE FLAGS FOR THE ENDING
	
	await get_tree().create_timer(1.0).timeout
	top.moveAnimation()
	bottom.moveAnimation()
	await get_tree().create_timer(1.0).timeout
	day_7.modulate.a = 1.0
	await get_tree().create_timer(3.0).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(day_7, "modulate:a", 0, 2.0)
	await get_tree().create_timer(5.0).timeout
	ending_title.modulate.a = 1.0
	await get_tree().create_timer(5.0).timeout
	return_to_main_menu.show()

func _on_return_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

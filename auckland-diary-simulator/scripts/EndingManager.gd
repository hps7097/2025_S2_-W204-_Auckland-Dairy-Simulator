# MADE WITH CHATGPT

# EndingManager.gd
extends Node

@onready var game_state = get_tree().root.get_node("Main/GameState")

func trigger_ending(ending_key: String):
	var scene = preload("res://scenes/EndingScreen.tscn").instantiate()
	get_tree().root.add_child(scene)
	match ending_key:
		"lawful": scene.set_text("You upheld the law…")
		"gang": scene.set_text("You fell into crime…")
		"neutral": scene.set_text("You stayed out of trouble…")


func show_ending(text: String):
	var popup = preload("res://scenes/popup_text.tscn").instantiate()
	popup.set_text(text)
	get_tree().root.add_child(popup)

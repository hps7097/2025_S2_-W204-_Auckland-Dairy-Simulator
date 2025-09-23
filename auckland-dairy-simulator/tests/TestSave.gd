# MADE WITH CHATGPT
extends GutTest

func _ready():
	var save = preload("res://scripts/SaveSystem.gd").new()
	save.save_game()
	save.load_game()
	assert(save.game_state.money >= 0)
	get_tree().quit()

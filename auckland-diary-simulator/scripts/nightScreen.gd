# MADE WITH CHATGPT

extends Control

# Hardcode or link to GameState constant
const MAX_DAYS: int = 7   # replace 30 with your actual max days

@onready var ending_manager: Node = get_tree().root.get_node("Main/EndingManager")

func check_for_game_end() -> void:
	if GameState.current_day > MAX_DAYS:
		var ending_key: String = ending_manager.determine_ending()
		var scene_path: String = "res://scenes/UI/Ending_%s.tscn" % ending_key
		if ResourceLoader.exists(scene_path):
			get_tree().change_scene_to_file(scene_path)
		else:
			push_warning("Ending scene missing: %s" % scene_path)

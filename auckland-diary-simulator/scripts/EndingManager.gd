# MADE WITH CHATGPT

# scripts/EndingManager.gd
extends Node

# Decide ending based on GameState flags, choices, etc.
func determine_ending() -> String:
    if GameState.get_flag("gang_path"):
        return "gang"
    elif GameState.get_flag("lawful_path"):
        return "lawful"
    else:
        return "neutral"

func trigger_ending() -> void:
    var ending_key: String = determine_ending()
    var path: String = "res://scenes/UI/Ending_%s.tscn" % ending_key
    
    if ResourceLoader.exists(path):
        get_tree().change_scene_to_file(path)
    else:
        push_warning("Missing ending scene: %s" % path)



# MADE WITH CHATGPT

extends Node

func determine_ending() -> String:
    if GameState.get_flag("gang_path"):
        return "gang"
    elif GameState.get_flag("lawful_path"):
        return "lawful"
    else:
        return "neutral"

func trigger_ending():
    var ending_key = determine_ending()
    var path = "res://scenes/UI/Ending_%s.tscn" % ending_key
    if ResourceLoader.exists(path):
        get_tree().change_scene_to_file(path)
    else:
        push_warning("Missing ending scene: %s" % path)


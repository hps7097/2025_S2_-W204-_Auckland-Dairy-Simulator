# MADE WITH CHATGPT

extends Node

# Tracks all player choices per run
var current_choices: Array = []
var history: Array = []
var QUIZ_AFTER := 3

func register_choice(choice_id:String, params:Variant = null) -> void:
	current_choices.append({"id": choice_id, "params": params})

# Determine ending type based on weighted choices or GameState flags
func determine_ending() -> String:
	var score := 0.0
	for c in current_choices:
		if typeof(c.params) == TYPE_DICTIONARY and c.params.has("weight"):
			score += float(c.params.weight)
		elif typeof(c.params) in [TYPE_INT, TYPE_FLOAT]:
			score += float(c.params)
	
	if score >= 5:
		return "good"
	elif score <= -5:
		return "bad"
	
	# fallback using GameState if available
	if Engine.has_singleton("GameState"):
		var gs = Engine.get_singleton("GameState")
		if gs.get_flag("gang_path"):
			return "gang"
		if gs.get_flag("lawful_path"):
			return "lawful"
	
	return "neutral"

func calculate_ending() -> String:
	var ending_id = determine_ending()
	history.append({"ending": ending_id, "choices": current_choices.duplicate(true)})
	current_choices.clear()
	return ending_id

func get_play_count() -> int:
	return history.size()

func should_show_quiz() -> bool:
	return get_play_count() >= QUIZ_AFTER

func get_history() -> Array:
	return history

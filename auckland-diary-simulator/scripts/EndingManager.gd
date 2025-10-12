# MADE WITH CHATGPT
extends Node

@onready var game_state = GameState

# Tracks all player choices per run
var current_choices: Array = []
var history: Array = []
const QUIZ_AFTER := 3

# Called at start of new playthrough
func start_new_run():
	current_choices.clear()
	game_state.start_new_run()

func register_choice(choice_id: String, params: Variant = null) -> void:
	current_choices.append({"id": choice_id, "params": params})
	game_state.record_choice(choice_id)

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

	# fallback logic (optional)
	return "neutral"

# Finalize and record ending
func calculate_ending() -> String:
	var ending_id = determine_ending()
	history.append({
		"ending": ending_id,
		"choices": current_choices.duplicate(true)
	})
	game_state.set_ending(ending_id)
	current_choices.clear()
	return ending_id

func get_play_count() -> int:
	return history.size()

func should_show_quiz() -> bool:
	return get_play_count() >= QUIZ_AFTER

func on_story_end():
	var ending = calculate_ending()
	game_state.save_to_file("autosave")

	if should_show_quiz():
		_show_external_quiz_message()
	else:
		get_tree().change_scene("res://scenes/MainMenu.tscn")




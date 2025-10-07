# MADE WITH CHATGPT

extends Node


# Stores choice events for the current playthrough
var current_choices := []
# History of playthroughs (each is a Dictionary with summary and ending id)
var history := []
# How many replays before asking the quiz
var QUIZ_AFTER := 3


func register_choice(choice_id:String, params= null) -> void:
# params can be any small Dictionary or value representing the player's choice
current_choices.append({"id":choice_id, "params": params})


func calculate_ending() -> String:
# Simple weighted example — replace with your project's branching logic
var score := 0
for c in current_choices:
if typeof(c.params) == TYPE_DICTIONARY and c.params.has("weight"):
score += c.params.weight
elif typeof(c.params) in [TYPE_INT, TYPE_REAL]:
score += float(c.params)
var ending_id := "neutral"
if score >= 5:
ending_id = "good"
elif score <= -5:
ending_id = "bad"
# store history snapshot (deep copy)
history.append({"ending": ending_id, "choices": current_choices.duplicate(true)})
# reset for next playthrough
current_choices.clear()
return ending_id


func get_play_count() -> int:
return history.size()


func should_show_quiz() -> bool:
return get_play_count() >= QUIZ_AFTER


func get_history() -> Array:
return history



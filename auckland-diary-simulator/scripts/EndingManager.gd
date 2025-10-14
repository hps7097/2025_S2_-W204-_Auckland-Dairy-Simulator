# MADE WITH CHATGPT
extends Node

@onready var game_state = GameState

# Track choices for current run
var current_choices: Array = []
var history: Array = []
const QUIZ_AFTER := 3

# Start a new run
func start_new_run() -> void:
    current_choices.clear()
    game_state.start_new_run()

# Register each story decision
func register_choice(choice_id: String, params: Variant = null) -> void:
    current_choices.append({"id": choice_id, "params": params})
    game_state.record_choice(choice_id)

# Compute the ending type
func determine_ending() -> String:
    var score := 0.0
    for c in current_choices:
        if typeof(c.params) == TYPE_DICTIONARY and c.params.has("weight"):
            score += float(c.params.weight)
        elif typeof(c.params) in [TYPE_INT, TYPE_FLOAT]:
            score += float(c.params)

    if score >= 5.0:
        return "good"
    elif score <= -5.0:
        return "bad"
    return "neutral"

# Finalize and save ending
func calculate_ending() -> String:
    var ending_id := determine_ending()
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

# Called when the story is finished
func on_story_end() -> void:
    var ending := calculate_ending()
    game_state.save_to_file("autosave")

    if should_show_quiz():
        _show_external_quiz_message()
    else:
        get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

# Display an external quiz reminder popup
func _show_external_quiz_message() -> void:
    var popup := AcceptDialog.new()
    popup.dialog_text = "You’ve finished 3 playthroughs! 🎉\n\nPlease complete our short replay value quiz outside the game:\n\n👉 https://example.com/your-quiz-link"
    add_child(popup)
    popup.popup_centered()
    popup.connect("confirmed", Callable(self, "_on_quiz_prompt_closed"))

func _on_quiz_prompt_closed() -> void:
    get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

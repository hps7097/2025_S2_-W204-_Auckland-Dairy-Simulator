class_name EndingManager
extends Node

@onready var game_state: GameState = GameState

var current_choices: Array = []
var history: Array = []
const QUIZ_AFTER := 3

func start_new_run() -> void:
    current_choices.clear()
    game_state.start_new_run()

func register_choice(choice_id: String, params: Variant = null) -> void:
    current_choices.append({"id": choice_id, "params": params})
    game_state.record_choice(choice_id)

func determine_ending() -> String:
    # Very small scoring heuristic — adapt weights as needed
    var score := 0.0
    for c in current_choices:
        var p := c.get("params", null)
        if typeof(p) == TYPE_DICTIONARY and p.has("weight"):
            score += float(p["weight"])
        elif typeof(p) in [TYPE_INT, TYPE_FLOAT]:
            score += float(p)
    if score >= 5:
        return "good"
    elif score <= -5:
        return "bad"
    return "neutral"

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

func on_story_end() -> void:
    var ending := calculate_ending()
    var saved := game_state.save_to_file("autosave")
    if not saved:
        push_warning("EndingManager.on_story_end: autosave failed.")
    if should_show_quiz():
        _show_external_quiz_message()
    else:
        get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func _show_external_quiz_message() -> void:
    print("Player reached %d playthroughs – prompt for external quiz." % QUIZ_AFTER)
    var popup := AcceptDialog.new()
    popup.dialog_text = "You've finished %d playthroughs! Please take the replay value quiz outside the game.\\n\\nLink: https://example.com/your-quiz-link" % QUIZ_AFTER
    add_child(popup)
    popup.popup_centered()
    popup.connect("confirmed", Callable(self, "_on_quiz_prompt_closed"))

func _on_quiz_prompt_closed() -> void:
    get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

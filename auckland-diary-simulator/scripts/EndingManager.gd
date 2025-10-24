# FIXED BY CHATGPT
class_name EndingManager
extends Node

@onready var game_state: GameState = GameState

var current_choices: Array = []       # [{id: String, params: {weight:int}}]
var history: Array = []               # [{ending:String, choices:Array}]
const QUIZ_AFTER := 3                 # show quiz after N playthroughs

func start_new_run() -> void:
    current_choices.clear()
    game_state.start_new_run()

func register_choice(choice_id: String, params: Variant = null) -> void:
    current_choices.append({"id": choice_id, "params": params})
    game_state.record_choice(choice_id)

func determine_ending() -> String:
    # Simple scoring rule: sum "weight" from params
    var score := 0
    for c in current_choices:
        var p = c.get("params", null)
        if typeof(p) == TYPE_DICTIONARY and p.has("weight"):
            score += int(p["weight"])
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

func should_show_quiz() -> bool:
    return get_play_count() >= QUIZ_AFTER

func get_play_count() -> int:
    return game_state.replay_count

func go_to_ending() -> void:
    var ending_id := calculate_ending()
    # If you want to gate with quiz after N runs:
    if should_show_quiz():
        _show_external_quiz_message()
    else:
        get_tree().change_scene_to_file("res://scenes/EndingScreen.tscn")

func _show_external_quiz_message() -> void:
    var popup := AcceptDialog.new()
    popup.dialog_text = "You've finished %d playthroughs!\nPlease complete the external quiz, then return to the main menu." % QUIZ_AFTER
    add_child(popup)
    popup.popup_centered()
    popup.confirmed.connect(_on_quiz_prompt_closed)

func _on_quiz_prompt_closed() -> void:
    get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

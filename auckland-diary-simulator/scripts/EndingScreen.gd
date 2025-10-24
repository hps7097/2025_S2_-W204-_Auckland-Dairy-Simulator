# MADE WITH CHATGPT
extends Control

@onready var ending_text: RichTextLabel = $ending_text

func _ready() -> void:
    var ending_id := "neutral"
    if GameState.runs.size() > 0:
        var last := GameState.runs.back()
        ending_id = String(last.get("ending", "neutral"))

    match ending_id:
        "good":
            ending_text.text = "GOOD ENDING\nYou crushed it today!"
        "bad":
            ending_text.text = "BAD ENDING\nRough day at the dairy."
        _:
            ending_text.text = "NEUTRAL ENDING\nIt was... fine."

func _on_return_pressed() -> void:
    get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")


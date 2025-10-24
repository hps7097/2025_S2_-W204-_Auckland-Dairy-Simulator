# FIXED BY CHATGPT
extends Control

@onready var label := $VBoxContainer/EndingLabel
@onready var replay_btn := $VBoxContainer/ReplayButton
@onready var menu_btn := $VBoxContainer/MenuButton
@onready var quiz_timer := $VBoxContainer/QuizTimer

func _ready() -> void:
    show_ending()

func show_ending() -> void:
    var ending_id := "neutral"
    if GameState.runs.size() > 0:
        var last := GameState.runs.back()
        ending_id = String(last.get("ending", "neutral"))

    match ending_id:
        "good":
            label.text = "GOOD ENDING\nYou crushed it today!"
        "bad":
            label.text = "BAD ENDING\nRough day at the dairy."
        _:
            label.text = "NEUTRAL ENDING\nIt was... fine."

    if EndingManager.should_show_quiz():
        quiz_timer.start()

func _on_ReplayButton_pressed() -> void:
    get_tree().change_scene_to_file("res://scenes/GameScene.tscn")

func _on_MenuButton_pressed() -> void:
    get_tree().change_scene_to_file("res://scenes/UI/MainMenu.tscn")

func _on_QuizTimer_timeout() -> void:
    get_tree().change_scene_to_file("res://scenes/UI/ReplayQuiz.tscn")


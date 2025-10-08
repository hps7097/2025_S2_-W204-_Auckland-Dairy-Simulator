#MADE WITH CHATGPT
extends Control


extends Control

@onready var label := $VBoxContainer/EndingLabel
@onready var replay_btn := $VBoxContainer/ReplayButton
@onready var menu_btn := $VBoxContainer/MenuButton
@onready var quiz_timer := $VBoxContainer/QuizTimer

func _ready() -> void:
	show_ending()

func show_ending() -> void:
	var ending_id := "neutral"
	if Engine.has_singleton("EndingManager"):
		ending_id = EndingManager.calculate_ending()
	label.text = "Ending: %s" % ending_id
	match ending_id:
		"good":
			label.text += "\nYou saved the farm — people remember you fondly."
		"bad":
			label.text += "\nThe farm closed. People talk about what could've been."
		_:
			label.text += "\nIt was... fine."

	if Engine.has_singleton("EndingManager") and EndingManager.should_show_quiz():
		quiz_timer.start()

func _on_ReplayButton_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/GameScene.tscn")

func _on_MenuButton_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/UI/MainMenu.tscn")

func _on_QuizTimer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/UI/ReplayQuiz.tscn")


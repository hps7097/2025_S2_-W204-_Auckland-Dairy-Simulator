#MADE WITH CHATGPT
extends Control


onready var label = $VBoxContainer/EndingLabel
onready var replay_btn = $VBoxContainer/ReplayButton
onready var menu_btn = $VBoxContainer/MenuButton


func show_ending():
var ending_id = EndingManager.calculate_ending()
label.text = "Ending: %s" % ending_id
# show flavor text based on id
if ending_id == "good":
label.text += "\nYou saved the farm — people remember you fondly."
elif ending_id == "bad":
label.text += "\nThe farm closed. People talk about what could've been."
else:
label.text += "\nIt was... fine."
# if enough playthroughs, transition to quiz after a short delay or button
if EndingManager.should_show_quiz():
$VBoxContainer/QuizTimer.start()


func _on_ReplayButton_pressed():
get_tree().change_scene("res://scenes/GameScene.tscn")


func _on_MenuButton_pressed():
get_tree().change_scene("res://scenes/MainMenu.tscn")


func _on_QuizTimer_timeout():
get_tree().change_scene("res://scenes/ReplayQuiz.tscn")

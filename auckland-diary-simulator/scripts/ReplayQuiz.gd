#MADE WITH CHATGPT

Extends Control


onready var submit_btn = $VBoxContainer/SubmitButton
onready var radio_group = [$VBoxContainer/Option1, $VBoxContainer/Option2, $VBoxContainer/Option3]


func _ready():
# Option text: e.g. "No, felt the same", "Some differences", "Very different / worth replaying"
pass


func _on_SubmitButton_pressed():
var selected = null
for r in radio_group:
if r.pressed:
selected = r.text
break
# store response in EndingManager.history's last entry for analysis
if EndingManager.get_play_count() > 0:
var last = EndingManager.history[EndingManager.get_play_count() - 1]
last["quiz_response"] = selected
# optionally write quiz responses to a small file for later analysis
get_tree().change_scene("res://scenes/MainMenu.tscn")

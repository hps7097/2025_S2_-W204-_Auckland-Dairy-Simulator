#MADE WITH CHATGPT

extends Control

@onready var game_state = GameState
@onready var save_list = $ScrollContainer/SaveList

func _ready():
    populate_saves()

func populate_saves():
	var saves = GameState.list_saves()
	var save_list = $ScrollContainer/SaveList
	for child in save_list.get_children():
		child.queue_free()

	for s in saves:
		var btn = Button.new()
		btn.text = s
		btn.connect("pressed", Callable(self, "_on_load_pressed").bind(s))
		save_list.add_child(btn)

	if saves.is_empty():
		var label = Label.new()
		label.text = "No saved games found."
		save_list.add_child(label)


func _on_Back_pressed():
    get_tree().change_scene("res://scenes/MainMenu.tscn")


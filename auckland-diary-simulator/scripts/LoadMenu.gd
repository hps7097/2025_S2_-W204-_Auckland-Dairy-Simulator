# MADE WITH CHATGPT
extends VBoxContainer

@onready var save_list = $ScrollContainer/SaveList

func _ready():
	_refresh_save_list()

func _refresh_save_list():
	save_list.queue_free_children()
	var saves = GameState.list_saves()
	for s in saves:
		var btn = Button.new()
		btn.text = s
		btn.connect("pressed", Callable(self, "_on_load_pressed").bind(s))
		save_list.add_child(btn)

func _on_load_pressed(save_name: String):
	var ok = GameState.load_from_file(save_name)
	if ok:
		get_tree().change_scene("res://scenes/GameScene.tscn")
	else:
		push_error("Failed to load save: " + save_name)

func _on_Back_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")


#MADE WITH CHATGPT

extends Control

@onready var game_state = get_node_or_null("/root/GameState")
@onready var save_list = $"ScrollContainer/SaveList"

func _ready():
    populate_saves()
    $Back.connect("pressed", Callable(self, "_on_Back_pressed"))

func populate_saves():
    # clear list
    for child in save_list.get_children():
        child.queue_free()
    var saves = []
    if game_state:
        saves = game_state.list_saves()
    for s in saves:
        var btn = Button.new()
        btn.text = s
        btn.connect("pressed", Callable(self, "_on_save_selected").bind(s))
        save_list.add_child(btn)
    if saves.empty():
        var label = Label.new()
        label.text = "No saved games found."
        save_list.add_child(label)

func _on_save_selected(save_name: String):
    if game_state:
        var ok = game_state.load_from_file(save_name)
        if ok:
            print("Loaded save:", save_name)
            # Optionally change scene; choose the scene that resumes gameplay
            get_tree().change_scene("res://scenes/MainScene.tscn")
        else:
            print("Failed to load save:", save_name)

func _on_Back_pressed():
    get_tree().change_scene("res://scenes/MainMenu.tscn")

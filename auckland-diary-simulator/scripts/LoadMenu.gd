#MADE WITH CHATGPT

extends Control

@onready var game_state = GameState
@onready var save_list = $ScrollContainer/SaveList

func _ready():
    populate_saves()

func populate_saves():
    save_list.queue_free_children() # clear old buttons
    var saves = game_state.list_saves()
    for save_name in saves:
        var btn = Button.new()
        btn.text = save_name
        btn.connect("pressed", Callable(self, "_on_save_selected").bind(save_name))
        save_list.add_child(btn)

func _on_save_selected(save_name: String):
    var success = game_state.load_from_file(save_name)
    if success:
        print("Loaded save: ", save_name)
        # Load whatever scene corresponds to that state:
        get_tree().change_scene("res://scenes/MainScene.tscn")
    else:
        print("Failed to load save!")

func _on_Back_pressed():
    get_tree().change_scene("res://scenes/MainMenu.tscn")

